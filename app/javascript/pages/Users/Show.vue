<script setup>
import { Link } from '@inertiajs/vue3'
import { Icon } from '@iconify/vue'
import { format } from 'date-fns'
import { ptBR } from 'date-fns/locale'

const props = defineProps({
  profile_user: Object,
  tournament_stats: Array,
  recent_matches: Array
})

const formatDate = (date) => {
  return format(new Date(date), "d 'de' MMM, yyyy", { locale: ptBR })
}

const formatDateTime = (date) => {
  return format(new Date(date), "d 'de' MMM, HH:mm", { locale: ptBR })
}
</script>

<template>
  <div class="max-w-3xl mx-auto px-4 py-8">
    <!-- Profile Header -->
    <div class="mb-8 flex items-center gap-4">
      <div class="w-16 h-16 rounded-full bg-theme-surface border border-theme-border flex items-center justify-center text-theme-muted">
        <Icon icon="mdi:account" class="w-8 h-8" />
      </div>
      <div>
        <h1 class="text-2xl font-bold text-theme-text">{{ profile_user.nickname }}</h1>
        <p class="text-sm text-theme-muted">Membro desde {{ formatDate(profile_user.created_at) }}</p>
      </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Tournament Stats -->
      <div class="lg:col-span-2 space-y-4">
        <h2 class="text-lg font-semibold text-theme-text flex items-center gap-2">
          <Icon icon="mdi:trophy" class="w-5 h-5 text-[#e3b341]" />
          Desempenho em Torneios
        </h2>

        <div class="space-y-3">
          <div v-for="stat in tournament_stats" :key="stat.id" class="bg-theme-surface rounded-md border border-theme-border p-4 hover:border-theme-muted transition-colors">
            <div class="flex justify-between items-start mb-2">
              <Link :href="`/tournaments/${stat.id}`" class="font-semibold text-theme-secondary hover:underline">
                {{ stat.name }}
              </Link>
              <span class="text-xs text-theme-muted">{{ formatDate(stat.created_at) }}</span>
            </div>
            
            <div class="flex items-center gap-6 text-sm">
              <div class="flex items-center gap-2">
                <span class="text-theme-muted">Ranking:</span>
                <span class="font-bold" :class="stat.rank === 1 ? 'text-[#e3b341]' : 'text-theme-text'">
                  #{{ stat.rank }}
                </span>
                <span class="text-xs text-theme-muted">de {{ stat.total_participants }}</span>
              </div>
              
              <div class="flex items-center gap-2">
                <span class="text-theme-muted">Pontuação:</span>
                <span class="font-bold text-theme-text">{{ stat.score }} pts</span>
              </div>
            </div>
          </div>

          <div v-if="tournament_stats.length === 0" class="p-8 rounded-md bg-theme-surface border border-dashed border-theme-border text-center">
            <p class="text-theme-muted text-sm">Nenhuma participação em torneios ainda.</p>
          </div>
        </div>
      </div>

      <!-- Recent Matches -->
      <div class="lg:col-span-1 space-y-4">
        <h2 class="text-lg font-semibold text-theme-text flex items-center gap-2">
          <Icon icon="mdi:history" class="w-5 h-5 text-theme-muted" />
          Partidas Recentes
        </h2>

        <div class="space-y-2">
          <div v-for="match in recent_matches" :key="match.id" class="p-3 rounded-md bg-theme-surface border border-theme-border text-sm">
            <div class="flex justify-between items-start mb-1">
              <span class="font-medium text-theme-text truncate max-w-[150px]">{{ match.tournament_name }}</span>
              <span class="text-xs text-theme-muted whitespace-nowrap">{{ formatDateTime(match.created_at) }}</span>
            </div>
            
            <div class="flex items-center gap-2 mt-2">
              <div v-if="match.is_winner" class="flex items-center gap-1 text-theme-primary text-xs font-bold">
                <Icon icon="mdi:trophy" class="w-3 h-3" />
                Venceu
              </div>
              <div v-else class="flex items-center gap-1 text-theme-muted text-xs">
                <span class="text-theme-muted">Vencedor:</span>
                <span class="text-theme-text">{{ match.winner_nickname || 'Empate' }}</span>
              </div>
            </div>
          </div>

          <div v-if="recent_matches.length === 0" class="p-6 rounded-md bg-theme-surface border border-dashed border-theme-border text-center">
            <p class="text-theme-muted text-sm">Nenhuma partida recente.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
