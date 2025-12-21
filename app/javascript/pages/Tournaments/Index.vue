<script setup>
import { Link } from '@inertiajs/vue3'
import { Icon } from '@iconify/vue'

defineProps({
  tournaments: Array
})

const formatDate = (dateString) => {
  return new Intl.DateTimeFormat('pt-BR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  }).format(new Date(dateString))
}
</script>

<template>
  <div class="max-w-3xl mx-auto px-4 py-8">
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-semibold text-theme-text">Torneios</h1>
      <Link href="/tournaments/new" class="hidden sm:flex items-center gap-2 px-3 py-1.5 rounded-md bg-theme-primary text-white font-medium hover:bg-github-btn-primary-hover transition-colors border border-[rgba(240,246,252,0.1)] shadow-sm text-sm">
        <Icon icon="mdi:plus" class="w-4 h-4" />
        Novo Torneio
      </Link>
    </div>

    <div class="grid grid-cols-1 gap-3">
      <Link v-for="tournament in tournaments" :key="tournament.id" :href="`/tournaments/${tournament.id}`" class="group block p-4 rounded-md bg-theme-surface border border-theme-border hover:border-theme-muted transition-all shadow-sm">
        <div class="flex justify-between items-start mb-2">
          <div>
            <h3 class="text-base font-semibold text-theme-secondary group-hover:underline transition-colors">{{ tournament.name }}</h3>
            <p class="text-xs text-theme-muted mt-1">Criado por <span class="text-theme-text">{{ tournament.created_by.nickname }}</span></p>
          </div>
          <div class="px-2 py-0.5 rounded-full bg-github-btn-bg text-xs font-medium text-theme-muted border border-theme-border flex items-center gap-1">
            <Icon icon="mdi:calendar" class="w-3 h-3" />
            {{ formatDate(tournament.created_at) }}
          </div>
        </div>
        
        <div class="flex items-center gap-4 text-xs text-theme-muted">
          <div class="flex items-center gap-1.5">
            <Icon icon="mdi:account-group" class="w-4 h-4" />
            <span>{{ tournament.participants_count }} participantes</span>
          </div>
          <div class="flex items-center gap-1.5">
            <Icon icon="mdi:cards-playing" class="w-4 h-4" />
            <span>{{ tournament.matches_count }} partidas</span>
          </div>
        </div>
      </Link>
    </div>
    
    <div v-if="tournaments.length === 0" class="text-center py-12 rounded-md bg-theme-surface border border-dashed border-theme-border">
      <div class="w-12 h-12 mx-auto mb-3 rounded-full bg-github-btn-bg flex items-center justify-center text-theme-muted">
        <Icon icon="mdi:trophy-broken" class="w-6 h-6" />
      </div>
      <h3 class="text-base font-medium text-theme-text">Nenhum torneio encontrado</h3>
      <p class="text-theme-muted text-sm mt-1">Crie o primeiro torneio para começar a liga!</p>
      <Link href="/tournaments/new" class="inline-flex items-center gap-2 mt-4 px-4 py-2 rounded-md bg-theme-primary text-white font-medium hover:bg-github-btn-primary-hover transition-colors sm:hidden shadow-sm text-sm">
        <Icon icon="mdi:plus" class="w-4 h-4" />
        Criar Torneio
      </Link>
    </div>
  </div>
</template>
