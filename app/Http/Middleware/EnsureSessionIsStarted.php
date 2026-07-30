<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureSessionIsStarted
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
   public function handle(Request $request, Closure $next)
    {
        // Ensure session is started
        if (!$request->hasSession()) {
            $request->setLaravelSession(app('session')->driver());
        }

        // Start session if not started
        if (!session()->isStarted()) {
            session()->start();
        }

        // Log session ID for debugging
        // \Log::info('Session middleware', [
        //     'session_id' => session()->getId(),
        //     'url' => $request->url()
        // ]);

        return $next($request);
    }
}
