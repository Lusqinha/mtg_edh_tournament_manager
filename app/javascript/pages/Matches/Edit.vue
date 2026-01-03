<script setup>
import { useForm, Link } from '@inertiajs/vue3'
import { computed, ref, watch } from 'vue'
import { Icon } from '@iconify/vue'

const props = defineProps({
  tournament: Object,
  match: Object,
  achievements: Array,
  scorings: Array
})

const form = useForm({
  winner_id: props.match.winner_id,
  duration: props.match.duration || 0,
  match_results: props.match.match_results.map(result => ({
    id: result.id,
    user_id: result.user_id,
    position: result.position,
    user: result.user
  })),
  match_achievements: props.match.match_achievements || []
})

// Calculate duration if not set
if (!form.duration && props.match.played_at) {
  const start = new Date(props.match.played_at)
  const now = new Date()
  form.duration = Math.floor((now - start) / 1000)
}

const toggleAchievement = (userId, achievementId) => {
  const index = form.match_achievements.findIndex(
    ma => ma.user_id === userId && ma.tournament_achievement_id === achievementId
  )
  
  if (index > -1) {
    form.match_achievements.splice(index, 1)
  } else {
    // Check if unique
    const achievement = props.achievements.find(a => a.id === achievementId)
    if (achievement.unique_completion) {
      // Remove from other users
      const otherIndex = form.match_achievements.findIndex(
        ma => ma.tournament_achievement_id === achievementId
      )
      if (otherIndex > -1) {
        form.match_achievements.splice(otherIndex, 1)
      }
    }
    
    form.match_achievements.push({
      user_id: userId,
      tournament_achievement_id: achievementId
    })
  }
}

const hasAchievement = (userId, achievementId) => {
  return form.match_achievements.some(
    ma => ma.user_id === userId && ma.tournament_achievement_id === achievementId
  )
}

const getPlayerScore = (userId) => {
  let score = 0
  
  // Position points
  const result = form.match_results.find(r => r.user_id === userId)
  if (result && result.position) {
    const scoring = props.scorings.find(s => s.position === parseInt(result.position))
    if (scoring) score += scoring.points
  }
  
  // Achievement points
  const userAchievements = form.match_achievements.filter(ma => ma.user_id === userId)
  userAchievements.forEach(ma => {
    const achievement = props.achievements.find(a => a.id === ma.tournament_achievement_id)
    if (achievement) score += achievement.points
  })
  
  return score
}

// Watch winner selection to set position 1
watch(() => form.winner_id, (newWinnerId) => {
  if (newWinnerId) {
    const result = form.match_results.find(r => r.user_id === newWinnerId)
    if (result) result.position = 1
  }
})

const submit = () => {
  form.put(`/tournaments/${props.tournament.slug}/matches/${props.match.id}`)
}
</script>

<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
    <div class="mb-8">
      <h1 class="text-2xl font-semibold text-theme-text mb-2">Finalizar Partida</h1>
      <div class="flex items-center gap-2 text-theme-muted text-sm">
        <Icon icon="mdi:clock-outline" class="w-4 h-4" />
        <span>Iniciada em {{ new Date(match.played_at).toLocaleTimeString('pt-BR', {hour: '2-digit', minute:'2-digit'}) }}</span>
      </div>
    </div>

    <form @submit.prevent="submit" class="space-y-8">
      <!-- Winner Selection -->
      <div class="bg-theme-surface rounded-md border border-theme-border p-6">
        <h3 class="text-lg font-semibold text-theme-text mb-4 flex items-center gap-2">
          <Icon icon="mdi:trophy" class="w-5 h-5 text-[#e3b341]" />
          Vencedor da Partida
        </h3>
        
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4">
          <div v-for="result in form.match_results" :key="result.user_id" class="relative">
            <input 
              type="radio" 
              :id="`winner_${result.user_id}`" 
              :value="result.user_id" 
              v-model="form.winner_id"
              class="peer sr-only"
            >
            <label :for="`winner_${result.user_id}`" class="flex flex-col items-center gap-2 p-4 rounded-md bg-theme-base border border-theme-border cursor-pointer transition-all hover:border-theme-muted peer-checked:bg-[#e3b341]/10 peer-checked:border-[#e3b341] peer-checked:text-[#e3b341] text-theme-muted">
              <div class="w-12 h-12 rounded-full bg-theme-surface border border-theme-border flex items-center justify-center peer-checked:border-[#e3b341] transition-all">
                <Icon icon="mdi:crown" class="w-6 h-6 opacity-20 peer-checked:opacity-100" />
              </div>
              <span class="font-medium text-sm">{{ result.user.nickname }}</span>
            </label>
          </div>
        </div>
      </div>

      <!-- Player Details -->
      <div class="space-y-4">
        <h3 class="text-lg font-semibold text-theme-text flex items-center gap-2">
          <Icon icon="mdi:account-details" class="w-5 h-5 text-theme-muted" />
          Detalhes por Jogador
        </h3>
        
        <div class="grid grid-cols-1 gap-6">
          <div v-for="result in form.match_results" :key="result.user_id" class="bg-theme-surface rounded-md border border-theme-border p-6 hover:border-theme-muted transition-all">
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6 border-b border-theme-border pb-4">
              <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-full bg-github-btn-bg flex items-center justify-center text-theme-text font-bold border border-theme-border">
                  {{ result.user.nickname[0].toUpperCase() }}
                </div>
                <div>
                  <strong class="text-lg text-theme-text block">{{ result.user.nickname }}</strong>
                  <span v-if="form.winner_id === result.user_id" class="text-xs text-[#e3b341] font-medium flex items-center gap-1">
                    <Icon icon="mdi:trophy" class="w-3 h-3" /> Vencedor
                  </span>
                </div>
              </div>
              
              <div class="flex items-center gap-4 bg-theme-base p-3 rounded-md border border-theme-border">
                <div class="flex items-center gap-2">
                  <label class="text-xs font-semibold text-theme-muted uppercase">Posição:</label>
                  <input v-model="result.position" type="number" min="1" class="w-16 px-2 py-1 rounded bg-theme-surface border border-theme-border text-theme-text text-center text-sm focus:border-theme-secondary outline-none" />
                </div>
                <div class="w-px h-8 bg-theme-border"></div>
                <div class="flex flex-col items-end">
                  <span class="text-xs text-theme-muted uppercase">Total de Pontos</span>
                  <span class="text-xl font-bold text-theme-secondary">{{ getPlayerScore(result.user_id) }}</span>
                </div>
              </div>
            </div>
            
            <!-- Achievements Selection -->
            <div v-if="achievements.length > 0">
              <h4 class="text-sm font-semibold text-theme-muted mb-3 flex items-center gap-2">
                <Icon icon="mdi:medal" class="w-4 h-4" />
                Conquistas
              </h4>
              <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
                <button 
                  v-for="achievement in achievements" 
                  :key="achievement.id"
                  type="button"
                  @click="toggleAchievement(result.user_id, achievement.id)"
                  class="text-left p-3 rounded-md border transition-all relative group"
                  :class="hasAchievement(result.user_id, achievement.id) 
                    ? 'bg-theme-primary/10 border-theme-primary text-theme-text' 
                    : 'bg-theme-base border-theme-border text-theme-muted hover:border-theme-muted'"
                >
                  <div class="flex justify-between items-start mb-1">
                    <span class="font-medium text-sm pr-6">{{ achievement.title }}</span>
                    <span class="text-xs font-bold" :class="achievement.points > 0 ? 'text-theme-primary' : 'text-red-400'">
                      {{ achievement.points > 0 ? '+' : '' }}{{ achievement.points }}
                    </span>
                  </div>
                  <p class="text-xs opacity-70 line-clamp-2">{{ achievement.description }}</p>
                  
                  <div v-if="hasAchievement(result.user_id, achievement.id)" class="absolute top-2 right-2">
                    <Icon icon="mdi:check-circle" class="w-4 h-4 text-theme-primary" />
                  </div>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="flex flex-col sm:flex-row gap-3 pt-6 border-t border-theme-border sticky bottom-0 bg-theme-base p-4 -mx-4 sm:mx-0 z-10">
        <button type="submit" :disabled="form.processing" class="flex-1 py-3 px-6 rounded-md bg-theme-primary text-white font-medium hover:bg-github-btn-primary-hover transition-colors border border-[rgba(240,246,252,0.1)] shadow-sm disabled:opacity-50 disabled:cursor-not-allowed text-base">
          {{ form.processing ? 'Salvando...' : 'Finalizar Partida' }}
        </button>
        <Link :href="`/tournaments/${tournament.slug}`" class="px-6 py-3 rounded-md bg-github-btn-bg text-theme-text font-medium hover:bg-github-btn-hover transition-colors border border-theme-border text-center text-base">
          Cancelar
        </Link>
      </div>
    </form>
  </div>
</template>
