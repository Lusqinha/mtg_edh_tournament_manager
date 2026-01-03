<script setup>
import { Icon } from '@iconify/vue'

defineProps({
  participants: Array
})

const getPositionClasses = (index) => {
  if (index === 0) return 'bg-[#e3b341]/20 text-[#e3b341] border-[#e3b341]/30'
  if (index === 1) return 'bg-[#c0c0c0]/20 text-[#c0c0c0] border-[#c0c0c0]/30'
  if (index === 2) return 'bg-[#cd7f32]/20 text-[#cd7f32] border-[#cd7f32]/30'
  return 'bg-theme-border/50 text-theme-muted border-theme-border'
}

const getPositionIcon = (index) => {
  if (index === 0) return 'mdi:trophy'
  if (index === 1) return 'mdi:medal'
  if (index === 2) return 'mdi:medal-outline'
  return null
}
</script>

<template>
  <!-- Mobile View (Cards) -->
  <div class="md:hidden space-y-2">
    <div 
      v-for="(participant, index) in participants" 
      :key="index" 
      class="bg-theme-surface rounded-md border border-theme-border p-3 transition-colors"
      :class="index < 3 ? 'border-l-2 ' + (index === 0 ? 'border-l-[#e3b341]' : index === 1 ? 'border-l-[#c0c0c0]' : 'border-l-[#cd7f32]') : ''"
    >
      <div class="flex items-center gap-3">
        <!-- Position Badge -->
        <div :class="['w-8 h-8 flex items-center justify-center rounded-full font-bold text-sm border', getPositionClasses(index)]">
          <Icon v-if="getPositionIcon(index)" :icon="getPositionIcon(index)" class="w-4 h-4" />
          <span v-else>{{ index + 1 }}</span>
        </div>
        
        <!-- Player Info -->
        <div class="flex-1 min-w-0">
          <div class="flex items-center justify-between gap-2">
            <span class="font-semibold text-theme-text truncate">{{ participant.user.nickname }}</span>
            <span class="font-bold text-theme-secondary text-lg whitespace-nowrap">{{ participant.score }} pts</span>
          </div>
          
          <!-- Stats Row -->
          <div class="flex items-center gap-4 mt-1 text-xs text-theme-muted">
            <span class="flex items-center gap-1">
              <Icon icon="mdi:cards-playing" class="w-3.5 h-3.5" />
              {{ participant.matches_played }}
            </span>
            <span class="flex items-center gap-1">
              <Icon icon="mdi:trophy-outline" class="w-3.5 h-3.5" />
              {{ participant.wins }}
            </span>
            <span class="flex items-center gap-1">
              <Icon icon="mdi:percent" class="w-3.5 h-3.5" />
              {{ participant.win_rate }}%
            </span>
          </div>
        </div>
      </div>
    </div>
    
    <div v-if="participants.length === 0" class="p-8 rounded-md bg-theme-surface border border-dashed border-theme-border text-center text-theme-muted">
      Nenhum participante registrado ainda.
    </div>
  </div>

  <!-- Desktop View (Table) -->
  <div class="hidden md:block bg-theme-surface rounded-md border border-theme-border overflow-hidden">
    <table class="w-full text-sm text-left">
      <thead class="text-xs text-theme-muted uppercase bg-theme-base border-b border-theme-border">
        <tr>
          <th class="px-4 py-3 font-medium w-16">Pos</th>
          <th class="px-4 py-3 font-medium">Jogador</th>
          <th class="px-4 py-3 font-medium text-center">Partidas</th>
          <th class="px-4 py-3 font-medium text-center">Vitórias</th>
          <th class="px-4 py-3 font-medium text-center">Win Rate</th>
          <th class="px-4 py-3 font-medium text-right">Pontos</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(participant, index) in participants" :key="index" class="border-b border-theme-border last:border-0 hover:bg-github-btn-bg/50 transition-colors">
          <td class="px-4 py-3">
            <div :class="['w-7 h-7 flex items-center justify-center rounded-full font-bold text-xs border', getPositionClasses(index)]">
              <Icon v-if="getPositionIcon(index)" :icon="getPositionIcon(index)" class="w-4 h-4" />
              <span v-else>{{ index + 1 }}</span>
            </div>
          </td>
          <td class="px-4 py-3 font-medium text-theme-text">{{ participant.user.nickname }}</td>
          <td class="px-4 py-3 text-center text-theme-muted">{{ participant.matches_played }}</td>
          <td class="px-4 py-3 text-center text-theme-muted">{{ participant.wins }}</td>
          <td class="px-4 py-3 text-center text-theme-muted">{{ participant.win_rate }}%</td>
          <td class="px-4 py-3 text-right font-bold text-theme-secondary">{{ participant.score }}</td>
        </tr>
        <tr v-if="participants.length === 0">
          <td colspan="6" class="px-4 py-8 text-center text-theme-muted">
            Nenhum participante registrado ainda.
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
