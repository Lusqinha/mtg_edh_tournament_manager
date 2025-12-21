<script setup>
import { Head, Link } from '@inertiajs/vue3';
import Layout from '@/layouts/Layout.vue';

defineProps({
  tournaments: Array,
});
</script>

<template>
  <Layout>
    <Head title="Select Tournament" />

    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <h1 class="text-2xl font-bold text-gray-900 mb-6">Select Tournament to Register Match</h1>

      <div v-if="tournaments.length === 0" class="text-center py-12 bg-white rounded-lg shadow">
        <p class="text-gray-500 mb-4">You don't have any active tournaments.</p>
        <Link
          href="/tournaments/new"
          class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          Create Tournament
        </Link>
      </div>

      <div v-else class="grid gap-4 sm:grid-cols-2">
        <Link
          v-for="tournament in tournaments"
          :key="tournament.id"
          :href="`/tournaments/${tournament.id}/matches/new`"
          class="block p-6 bg-white rounded-lg border border-gray-200 shadow-sm hover:bg-gray-50 hover:border-indigo-300 transition-colors duration-200"
        >
          <h3 class="text-lg font-medium text-gray-900 truncate">{{ tournament.name }}</h3>
          <p class="mt-1 text-sm text-gray-500">
            {{ new Date(tournament.created_at).toLocaleDateString() }}
          </p>
          <div class="mt-4 flex items-center text-indigo-600 text-sm font-medium">
            Register Match
            <svg class="ml-1 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </div>
        </Link>
      </div>
    </div>
  </Layout>
</template>
