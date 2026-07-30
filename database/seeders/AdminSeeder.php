<?php

namespace Database\Seeders;

use App\Models\User;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Auth\Events\Registered;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
         $user=User::create([
            'name' => 'Eman Esmail',
            'email' => 'emanesmailzidan@gmail.com',
            'password' => bcrypt('admin123'),
            'is_admin' => true
        ]);
        event(new Registered($user));
    }
}
