<template>

    <GuestLayout title="Set new password">

        <form class="space-y-6" action="#" method="POST">
            <input type="hidden" name="remember" value="true" />


                <div>
                    <label for="new-password" class="sr-only">New Password</label>
                    <input id="new-password" name="password" type="password" required=""
                        class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                        placeholder="New Password" />
                </div>

                <div>
                    <label for="password-repeat" class="sr-only">Repeat Password</label>
                    <input id="password-repeat" name="password_repeat" type="password" required=""
                        class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                        placeholder="Repeat Password" />
                </div>

                <div class="text-sm">

                    <router-link :to="{name: 'login'}" class="font-semibold text-indigo-600 hover:text-indigo-500"> Go back to Login
                    </router-link>
                </div>




            <div>
                <button type="submit"
                    class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm/6 font-semibold text-white shadow-xs hover:bg-indigo-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Sign
                    in</button>
            </div>
        </form>

    </GuestLayout>
</template>




<script setup>
import GuestLayout from '../components/GuestLayout.vue';



</script>

<style>
/* Global styles */
</style>
