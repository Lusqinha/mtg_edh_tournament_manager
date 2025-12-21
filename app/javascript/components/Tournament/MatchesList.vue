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
        <div class="flex items-center gap-2">
          <span class="text-sm text-theme-muted">Vencedor:</span>
          <span class="font-semibold text-theme-secondary">{{ match.winner ? match.winner.nickname : 'Empate' }}</span>
        </div>
        <span class="text-xs text-theme-muted">{{ formatDate(match.created_at) }}</span>
      </div>
      <div class="text-xs text-theme-muted">
        Registrado por {{ match.created_by.nickname }}
      </div>
    </div>
    <div v-if="matches.length === 0" class="p-12 rounded-md bg-theme-surface border border-dashed border-theme-border text-center">
      <Icon icon="mdi:cards-playing-outline" class="w-12 h-12 text-theme-muted mx-auto mb-3 opacity-50" />
      <p class="text-theme-muted">Nenhuma partida registrada ainda</p>
    </div>
  </div>
</template>
