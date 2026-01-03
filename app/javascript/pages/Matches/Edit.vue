<script setup>
import { useForm, Link } from '@inertiajs/vue3'
import { computed, ref, watch, onMounted, onUnmounted } from 'vue'
import { Icon } from '@iconify/vue'

const props = defineProps({
  tournament: Object,
  match: Object,
  achievements: Array,
  scorings: Array
})

// Check if this is a past match (duration already set from backend)
const isPastMatch = computed(() => props.match.duration !== null && props.match.duration > 0)

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

// Live timer for live matches
const elapsedTime = ref(0)
let timerInterval = null

const formatDuration = (seconds) => {
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  const secs = seconds % 60
  
  if (hours > 0) {
    return `${hours}h ${minutes}min`
  }
  return `${minutes}min ${secs}s`
}

onMounted(() => {
  if (!isPastMatch.value && props.match.played_at) {
    const start = new Date(props.match.played_at)
    
    const updateElapsed = () => {
      const now = new Date()
      elapsedTime.value = Math.floor((now - start) / 1000)
      form.duration = elapsedTime.value
    }
    
    updateElapsed()
    timerInterval = setInterval(updateElapsed, 1000)
  } else {
    elapsedTime.value = form.duration
  }
})

onUnmounted(() => {
  if (timerInterval) {
    clearInterval(timerInterval)
  }
})

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
  <div class="max-w-4xl mx-auto px-4 py-6">
    <!-- Header -->
    <div class="mb-6">
      <div class="flex items-start justify-between gap-4 mb-3">
        <div>
          <h1 class="text-xl font-semibold text-theme-text">Finalizar Partida</h1>
          <p class="text-sm text-theme-muted mt-0.5">{{ tournament.name }}</p>
        </div>
        
        <!-- Timer/Duration Badge -->
        <div :class="['px-3 py-2 rounded-lg text-center', isPastMatch ? 'bg-theme-secondary/10 border border-theme-secondary/20' : 'bg-theme-primary/10 border border-theme-primary/20']">
          <div class="text-xs text-theme-muted uppercase tracking-wide">Duração</div>
          <div :class="['text-lg font-bold tabular-nums', isPastMatch ? 'text-theme-secondary' : 'text-theme-primary']">
            {{ formatDuration(elapsedTime) }}
          </div>
        </div>
      </div>
      
      <div class="flex items-center gap-3 text-xs text-theme-muted">
        <span class="flex items-center gap-1">
          <Icon icon="mdi:calendar" class="w-3.5 h-3.5" />
          {{ new Date(match.played_at).toLocaleDateString('pt-BR') }}
        </span>
        <span class="flex items-center gap-1">
          <Icon icon="mdi:clock-outline" class="w-3.5 h-3.5" />
          {{ new Date(match.played_at).toLocaleTimeString('pt-BR', {hour: '2-digit', minute:'2-digit'}) }}
        </span>
        <span v-if="!isPastMatch" class="flex items-center gap-1 text-theme-primary">
          <span class="w-2 h-2 rounded-full bg-theme-primary animate-pulse"></span>
          Ao vivo
        </span>
      </div>
    </div>

    <form @submit.prevent="submit" class="space-y-6">
      <!-- Winner Selection -->
      <div class="bg-theme-surface rounded-md border border-theme-border p-4">
        <h3 class="text-sm font-semibold text-theme-text mb-3 flex items-center gap-2">
          <Icon icon="mdi:trophy" class="w-4 h-4 text-[#e3b341]" />
          Vencedor da Partida
        </h3>
        
        <div class="grid grid-cols-2 sm:grid-cols-4 gap-2">
          <div v-for="result in form.match_results" :key="result.user_id" class="relative">
            <input 
              type="radio" 
              :id="`winner_${result.user_id}`" 
              :value="result.user_id" 
              v-model="form.winner_id"
              class="peer sr-only"
            >
            <label :for="`winner_${result.user_id}`" class="flex items-center justify-center gap-2 p-3 rounded-md bg-theme-base border border-theme-border cursor-pointer transition-all hover:border-theme-muted peer-checked:bg-[#e3b341]/10 peer-checked:border-[#e3b341] peer-checked:text-[#e3b341] text-theme-muted">
              <Icon icon="mdi:crown" class="w-4 h-4 opacity-30 peer-checked:opacity-100" />
              <span class="font-medium text-sm truncate">{{ result.user.nickname }}</span>
            </label>
          </div>
        </div>
      </div>

      <!-- Player Details -->
      <div class="space-y-4">
        <h3 class="text-sm font-semibold text-theme-text flex items-center gap-2">
          <Icon icon="mdi:account-details" class="w-4 h-4 text-theme-muted" />
          Resultados por Jogador
        </h3>
        
        <div class="space-y-3">
          <div v-for="result in form.match_results" :key="result.user_id" class="bg-theme-surface rounded-md border border-theme-border overflow-hidden">
            <!-- Player Header -->
            <div class="p-3 border-b border-theme-border bg-theme-base/50">
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                  <div class="w-8 h-8 rounded-full bg-github-btn-bg flex items-center justify-center text-theme-text font-bold text-sm border border-theme-border">
                    {{ result.user.nickname[0].toUpperCase() }}
                  </div>
                  <div>
                    <strong class="text-sm text-theme-text">{{ result.user.nickname }}</strong>
                    <span v-if="form.winner_id === result.user_id" class="ml-2 text-[10px] text-[#e3b341] font-bold uppercase">
                      <Icon icon="mdi:trophy" class="w-3 h-3 inline" /> Vencedor
                    </span>
                  </div>
                </div>
                
                <div class="text-right">
                  <div class="text-xs text-theme-muted">Pontos</div>
                  <div class="text-lg font-bold text-theme-secondary">{{ getPlayerScore(result.user_id) }}</div>
                </div>
              </div>
            </div>
            
            <!-- Position Input -->
            <div class="p-3 border-b border-theme-border">
              <div class="flex items-center justify-between">
                <label class="text-xs font-medium text-theme-muted">Posição Final</label>
                <div class="flex items-center gap-2">
                  <button type="button" @click="result.position = Math.max(1, (result.position || 1) - 1)" class="w-8 h-8 rounded bg-theme-base border border-theme-border flex items-center justify-center text-theme-muted hover:text-theme-text hover:border-theme-muted transition-colors">
                    <Icon icon="mdi:minus" class="w-4 h-4" />
                  </button>
                  <input v-model="result.position" type="number" min="1" class="w-12 px-2 py-1.5 rounded bg-theme-base border border-theme-border text-theme-text text-center text-sm focus:border-theme-secondary outline-none" />
                  <button type="button" @click="result.position = (result.position || 0) + 1" class="w-8 h-8 rounded bg-theme-base border border-theme-border flex items-center justify-center text-theme-muted hover:text-theme-text hover:border-theme-muted transition-colors">
                    <Icon icon="mdi:plus" class="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>
            
            <!-- Achievements Selection -->
            <div v-if="achievements.length > 0" class="p-3">
              <h4 class="text-xs font-medium text-theme-muted mb-2">Conquistas</h4>
              <div class="flex flex-wrap gap-2">
                <button 
                  v-for="achievement in achievements" 
                  :key="achievement.id"
                  type="button"
                  @click="toggleAchievement(result.user_id, achievement.id)"
                  class="inline-flex items-center gap-1.5 px-2.5 py-1.5 rounded-full text-xs font-medium border transition-all cursor-pointer"
                  :class="hasAchievement(result.user_id, achievement.id) 
                    ? 'bg-theme-primary/10 border-theme-primary text-theme-primary' 
                    : 'bg-theme-base border-theme-border text-theme-muted hover:border-theme-muted'"
                >
                  <Icon v-if="hasAchievement(result.user_id, achievement.id)" icon="mdi:check-circle" class="w-3.5 h-3.5" />
                  <Icon v-else icon="mdi:plus-circle-outline" class="w-3.5 h-3.5" />
                  {{ achievement.title }}
                  <span :class="achievement.points > 0 ? 'text-theme-secondary' : 'text-red-400'">
                    {{ achievement.points > 0 ? '+' : '' }}{{ achievement.points }}
                  </span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Actions -->
      <div class="fixed bottom-0 left-0 right-0 bg-theme-surface border-t border-theme-border p-4 z-20 sm:static sm:bg-transparent sm:border-0 sm:p-0 sm:pt-4">
        <div class="flex flex-col-reverse sm:flex-row gap-2 max-w-4xl mx-auto">
          <Link :href="`/tournaments/${tournament.slug}`" class="px-4 py-2.5 rounded-md bg-github-btn-bg text-theme-text font-medium hover:bg-github-btn-hover transition-colors border border-theme-border text-center text-sm">
            Cancelar
          </Link>
          <button type="submit" :disabled="form.processing || !form.winner_id" class="flex-1 py-2.5 px-4 rounded-md bg-theme-primary text-white font-medium hover:bg-github-btn-primary-hover transition-colors border border-[rgba(240,246,252,0.1)] shadow-sm disabled:opacity-50 disabled:cursor-not-allowed text-sm">
            {{ form.processing ? 'Salvando...' : 'Finalizar Partida' }}
          </button>
        </div>
      </div>
      
      <!-- Spacer for fixed bottom bar on mobile -->
      <div class="h-20 sm:hidden"></div>
    </form>
  </div>
</template>
