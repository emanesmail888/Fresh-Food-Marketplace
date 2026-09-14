<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Contact;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
use App\Mail\ContactMail;
use Illuminate\Support\Facades\Validator;


class ContactController extends Controller
{
    /**
     * Display a listing of contact messages (Admin)
     */

    public function index(Request $request)
    {
        try {
            $query = Contact::query();

            // Apply status filter
            if ($request->has('status') && $request->status !== 'all' && !empty($request->status)) {
                $query->where('status', $request->status);
            }

            // Apply search
            if ($request->has('search') && !empty($request->search)) {
                $search = $request->search;
                $query->where(function($q) use ($search) {
                    $q->where('name', 'LIKE', "%{$search}%")
                    ->orWhere('email', 'LIKE', "%{$search}%")
                    ->orWhere('subject', 'LIKE', "%{$search}%")
                    ->orWhere('message', 'LIKE', "%{$search}%");
                });
            }

            $perPage = $request->input('per_page', 10);
            $contacts = $query->orderBy('created_at', 'desc')->paginate($perPage);

            // Log the results
            // \Log::info('Contacts fetched', [
            //     'total' => $contacts->total(),
            //     'per_page' => $perPage,
            //     'status' => $request->status
            // ]);

            return response()->json([
                'success' => true,
                'data' => $contacts // This is the pagination object
            ]);

        } catch (\Exception $e) {
            // \Log::error('Failed to fetch contacts: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch contacts'
            ], 500);
        }
    }

    /**
     * Store a newly created contact message
     */
    public function store(Request $request)
    {
        try {
            // Validate the request
            $validator = Validator::make($request->all(), [
                'name' => 'required|string|max:255',
                'email' => 'required|email|max:255',
                'phone' => 'nullable|string|max:20',
                'subject' => 'nullable|string|max:255',
                'message' => 'required|string|min:10',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            // Create contact record
            $contact = Contact::create([
                'name' => $request->name,
                'email' => $request->email,
                'phone' => $request->phone,
                'subject' => $request->subject,
                'message' => $request->message,
                'status' => 'pending',
                'user_id' => $request->user() ? $request->user()->id : null,
                'ip_address' => $request->ip(),
                'user_agent' => $request->userAgent(),
            ]);

            // Send email notification
            try {
                Mail::to(config('mail.from.address'))->send(new ContactMail($contact));
                Mail::to($contact->email)->send(new ContactMail($contact, 'customer'));
            } catch (\Exception $e) {
                Log::error('Failed to send contact email: ' . $e->getMessage());
            }

            Log::info('New contact message received', [
                'contact_id' => $contact->id,
                'email' => $contact->email,
                'ip' => $request->ip()
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Your message has been sent successfully!',
                'data' => $contact
            ], 201);

        } catch (\Exception $e) {
            Log::error('Failed to store contact: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to send message',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified contact message
     */
    public function show($id)
    {
        try {
            $contact = Contact::findOrFail($id);

            // Mark as read
            if ($contact->status === 'pending') {
                $contact->update([
                    'status' => 'read',
                    'read_at' => now()
                ]);
            }

            return response()->json([
                'success' => true,
                'data' => $contact
            ]);

        } catch (\Exception $e) {
            Log::error('Failed to fetch contact: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Contact message not found'
            ], 404);
        }
    }

    /**
     * Update the specified contact message status
     */
    public function update(Request $request, $id)
    {
        try {
            $contact = Contact::findOrFail($id);

            $validator = Validator::make($request->all(), [
                'status' => 'required|in:pending,read,replied,archived',
                'admin_notes' => 'nullable|string',
                'reply' => 'nullable|string',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            $contact->update([
                'status' => $request->status,
                'admin_notes' => $request->admin_notes,
                'reply' => $request->reply,
                'replied_at' => $request->status === 'replied' ? now() : $contact->replied_at,
                'updated_by' => $request->user() ? $request->user()->id : null,
            ]);

            // If replied, send reply email
            if ($request->status === 'replied' && !empty($request->reply)) {
                try {
                    Mail::to($contact->email)->send(new ContactMail($contact, 'reply'));
                } catch (\Exception $e) {
                    Log::error('Failed to send reply email: ' . $e->getMessage());
                }
            }

            return response()->json([
                'success' => true,
                'message' => 'Contact message updated successfully',
                'data' => $contact
            ]);

        } catch (\Exception $e) {
            Log::error('Failed to update contact: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to update contact message',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified contact message
     */
    public function destroy($id)
    {
        try {
            $contact = Contact::findOrFail($id);
            $contact->delete();

            Log::info('Contact message deleted', ['contact_id' => $id]);

            return response()->json([
                'success' => true,
                'message' => 'Contact message deleted successfully'
            ]);

        } catch (\Exception $e) {
            Log::error('Failed to delete contact: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to delete contact message',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Bulk delete contact messages
     */
    public function bulkDelete(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'ids' => 'required|array',
                'ids.*' => 'required|integer|exists:contacts,id'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            $deleted = Contact::whereIn('id', $request->ids)->delete();

            return response()->json([
                'success' => true,
                'message' => "{$deleted} contact messages deleted successfully"
            ]);

        } catch (\Exception $e) {
            Log::error('Failed to bulk delete contacts: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to delete contact messages',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get contact statistics
     */
    public function stats()
    {
        try {
            $stats = [
                'total' => Contact::count(),
                'pending' => Contact::where('status', 'pending')->count(),
                'read' => Contact::where('status', 'read')->count(),
                'replied' => Contact::where('status', 'replied')->count(),
                'archived' => Contact::where('status', 'archived')->count(),
                'today' => Contact::whereDate('created_at', today())->count(),
                'this_week' => Contact::whereBetween('created_at', [now()->startOfWeek(), now()->endOfWeek()])->count(),
                'this_month' => Contact::whereMonth('created_at', now()->month)->count(),
            ];

            return response()->json([
                'success' => true,
                'data' => $stats
            ]);

        } catch (\Exception $e) {
            Log::error('Failed to get contact stats: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to get statistics',
                'error' => $e->getMessage()
            ], 500);
        }
    }

}
