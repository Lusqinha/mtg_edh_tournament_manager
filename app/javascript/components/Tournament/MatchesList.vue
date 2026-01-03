<script setup>
import { Icon } from '@iconify/vue'
import { format } from 'date-fns'
import { ptBR } from 'date-fns/locale'

defineProps({
  matches: Array
})

const formatDate = (dateString) => {
  return format(new Date(dateString), "dd/MM/yyyy HH:mm", { locale: ptBR })
}
</script>

<template>
  <div class="grid gap-4">
    <div v-for="match in matches" :key="match.id" class="p-4 rounded-md bg-theme-surface border border-theme-border hover:border-theme-muted transition-all">
      <div class="flex justify-between items-start mb-2">
        <div class="flex items-center gap-3">
          <span class="text-sm text-theme-muted">Vencedor:</span>
          <div v-if="match.winner" class="flex items-center gap-2">
            <div class="w-6 h-6 rounded-full bg-theme-base border border-theme-border overflow-hidden flex items-center justify-center shrink-0">
              <img v-if="match.winner.avatar_url" :src="match.winner.avatar_url" :alt="match.winner.nickname" class="w-full h-full object-cover" />
              <Icon v-else icon="mdi:account" class="w-3 h-3 text-theme-muted" />
            </div>
            <span class="font-semibold text-theme-secondary">{{ match.winner.nickname }}</span>
          </div>
          <span v-else class="font-semibold text-theme-muted">Empate</span>
        </div>
        <span class="text-xs text-theme-muted whitespace-nowrap">{{ formatDate(match.created_at) }}</span>
      </div>
      <div class="flex items-center gap-2 text-xs text-theme-muted">
        <span>Registrado por</span>
        <div class="flex items-center gap-1">
          <div class="w-4 h-4 rounded-full bg-theme-base border border-theme-border overflow-hidden flex items-center justify-center shrink-0">
            <img v-if="match.created_by.avatar_url" :src="match.created_by.avatar_url" :alt="match.created_by.nickname" class="w-full h-full object-cover" />
            <Icon v-else icon="mdi:account" class="w-2 h-2 text-theme-muted" />
          </div>
          <span>{{ match.created_by.nickname }}</span>
        </div>
      </div>
    </div>
    <div v-if="matches.length === 0" class="p-12 rounded-md bg-theme-surface border border-dashed border-theme-border text-center">
      <Icon icon="mdi:cards-playing-outline" class="w-12 h-12 text-theme-muted mx-auto mb-3 opacity-50" />
      <p class="text-theme-muted">Nenhuma partida registrada ainda</p>
    </div>
  </div>
</template>
