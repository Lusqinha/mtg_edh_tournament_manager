<script setup>
import { Link, router } from '@inertiajs/vue3'
import { ref } from 'vue'
import { Icon } from '@iconify/vue'
import AddPlayerModal from '../../components/Tournament/AddPlayerModal.vue'
import StandingsList from '../../components/Tournament/StandingsList.vue'
import MatchesList from '../../components/Tournament/MatchesList.vue'

const props = defineProps({
  tournament: Object,
  participants: Array,
  matches: Array,
  available_users: Array
})

const showAddPlayerModal = ref(false)
const showMatchTypeModal = ref(false)
const activeTab = ref('standings') // standings, matches, rules

const copyInviteLink = () => {
  const url = `${window.location.origin}/invite/${props.tournament.invite_code}`
  navigator.clipboard.writeText(url).then(() => {
    alert('Link de convite copiado para a área de transferência!')
  })
}

const startMatch = (type) => {
  showMatchTypeModal.value = false
  router.visit(`/tournaments/${props.tournament.slug}/matches/new?type=${type}`)
}
</script>

<template>
  <div class="max-w-5xl mx-auto px-4 py-8">
    <div class="mb-8">
      <div class="flex items-center gap-3 mb-6">
        <Link href="/tournaments" class="p-1.5 rounded-md hover:bg-github-btn-bg transition-colors text-theme-muted hover:text-theme-secondary">
          <Icon icon="mdi:arrow-left" class="w-5 h-5" />
        </Link>
        <div>
          <h1 class="text-xl font-semibold text-theme-text">{{ tournament.name }}</h1>
          <p class="text-xs text-theme-muted">Organizado por {{ tournament.created_by.nickname }}</p>
        </div>
      </div>

      <div v-if="tournament.is_organizer || tournament.is_participant" class="flex gap-3 mb-8 overflow-x-auto pb-2 custom-scrollbar">
        <button @click="showMatchTypeModal = true" class="flex items-center gap-2 px-4 py-2 rounded-md bg-theme-primary text-white font-medium text-sm hover:bg-github-btn-primary-hover transition-colors whitespace-nowrap border border-[rgba(240,246,252,0.1)] shadow-sm cursor-pointer">
          <Icon icon="mdi:sword-cross" class="w-4 h-4" />
          <span class="hidden sm:inline">Registrar Partida</span>
        </button>
        
        <button v-if="tournament.is_organizer" @click="showAddPlayerModal = true" class="flex items-center gap-2 px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium text-sm hover:bg-github-btn-hover transition-colors whitespace-nowrap border border-theme-border cursor-pointer">
          <Icon icon="mdi:account-plus" class="w-4 h-4" />
          <span class="hidden sm:inline">Adicionar Jogador</span>
        </button>

        <button v-if="tournament.is_organizer && tournament.invite_code" @click="copyInviteLink" class="flex items-center gap-2 px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium text-sm hover:bg-github-btn-hover transition-colors whitespace-nowrap border border-theme-border cursor-pointer">
          <Icon icon="mdi:share-variant" class="w-4 h-4" />
          <span class="hidden sm:inline">Convidar</span>
        </button>

        <Link v-if="tournament.is_organizer" :href="`/tournaments/${tournament.slug}/edit`" class="flex items-center gap-2 px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium text-sm hover:bg-github-btn-hover transition-colors whitespace-nowrap border border-theme-border">
          <Icon icon="mdi:pencil" class="w-4 h-4" />
          <span class="hidden sm:inline">Editar Torneio</span>
        </Link>
      </div>

      <AddPlayerModal 
        :show="showAddPlayerModal" 
        :available-users="available_users" 
        :tournament-slug="tournament.slug"
        @close="showAddPlayerModal = false"
      />

      <!-- Match Type Modal -->
      <div v-if="showMatchTypeModal" class="fixed inset-0 z-50 flex items-end sm:items-center justify-center p-0 sm:p-4 bg-theme-base/80 backdrop-blur-sm" @click.self="showMatchTypeModal = false">
        <div class="bg-theme-surface rounded-t-xl sm:rounded-xl border border-theme-border shadow-xl w-full sm:max-w-sm overflow-hidden animate-slide-up sm:animate-none">
          <div class="p-4 border-b border-theme-border">
            <div class="flex items-center justify-between">
              <h3 class="text-lg font-semibold text-theme-text">Registrar Partida</h3>
              <button @click="showMatchTypeModal = false" class="p-1 rounded-md hover:bg-github-btn-bg text-theme-muted hover:text-theme-text transition-colors">
                <Icon icon="mdi:close" class="w-5 h-5" />
              </button>
            </div>
            <p class="text-sm text-theme-muted mt-1">Que tipo de partida você quer registrar?</p>
          </div>
          
          <div class="p-4 space-y-3">
            <button 
              @click="startMatch('live')" 
              class="w-full p-4 rounded-lg bg-theme-base border border-theme-border hover:border-theme-primary hover:bg-theme-primary/5 transition-all text-left group cursor-pointer"
            >
              <div class="flex items-start gap-3">
                <div class="w-10 h-10 rounded-full bg-theme-primary/10 flex items-center justify-center flex-shrink-0 group-hover:bg-theme-primary/20 transition-colors">
                  <Icon icon="mdi:play-circle" class="w-5 h-5 text-theme-primary" />
                </div>
                <div>
                  <span class="font-semibold text-theme-text block">Partida ao Vivo</span>
                  <span class="text-xs text-theme-muted">A partida vai começar agora. O tempo será contabilizado automaticamente.</span>
                </div>
              </div>
            </button>
            
            <button 
              @click="startMatch('past')" 
              class="w-full p-4 rounded-lg bg-theme-base border border-theme-border hover:border-theme-secondary hover:bg-theme-secondary/5 transition-all text-left group cursor-pointer"
            >
              <div class="flex items-start gap-3">
                <div class="w-10 h-10 rounded-full bg-theme-secondary/10 flex items-center justify-center flex-shrink-0 group-hover:bg-theme-secondary/20 transition-colors">
                  <Icon icon="mdi:history" class="w-5 h-5 text-theme-secondary" />
                </div>
                <div>
                  <span class="font-semibold text-theme-text block">Partida Passada</span>
                  <span class="text-xs text-theme-muted">Registrar uma partida que já aconteceu. Você poderá informar a duração manualmente.</span>
                </div>
              </div>
            </button>
          </div>
          
          <div class="p-4 border-t border-theme-border sm:hidden">
            <button @click="showMatchTypeModal = false" class="w-full py-2.5 rounded-md bg-github-btn-bg text-theme-text font-medium hover:bg-github-btn-hover transition-colors border border-theme-border text-sm">
              Cancelar
            </button>
          </div>
        </div>
      </div>

      <!-- Tabs -->
      <div class="border-b border-theme-border mb-6 overflow-x-auto overflow-y-hidden custom-scrollbar">
        <nav class="-mb-px flex space-x-8" aria-label="Tabs">
          <button @click="activeTab = 'standings'" :class="[activeTab === 'standings' ? 'border-theme-secondary text-theme-secondary' : 'border-transparent text-theme-muted hover:text-theme-text hover:border-theme-muted', 'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm flex items-center gap-2']">
            <Icon icon="mdi:podium" class="w-4 h-4" />
            <span class="hidden sm:inline">Classificação</span>
            <span class="sm:hidden">Rank</span>
          </button>
          <button @click="activeTab = 'matches'" :class="[activeTab === 'matches' ? 'border-theme-secondary text-theme-secondary' : 'border-transparent text-theme-muted hover:text-theme-text hover:border-theme-muted', 'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm flex items-center gap-2']">
            <Icon icon="mdi:flash" class="w-4 h-4" />
            <span class="hidden sm:inline">Partidas</span>
            <span class="sm:hidden">Jogos</span>
          </button>
          <button @click="activeTab = 'rules'" :class="[activeTab === 'rules' ? 'border-theme-secondary text-theme-secondary' : 'border-transparent text-theme-muted hover:text-theme-text hover:border-theme-muted', 'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm flex items-center gap-2']">
            <Icon icon="mdi:book-open-variant" class="w-4 h-4" />
            <span class="hidden sm:inline">Regras e Pontuação</span>
            <span class="sm:hidden">Regras</span>
          </button>
        </nav>
      </div>

      <!-- Content -->
      <div>
        <!-- Standings Tab -->
        <div v-if="activeTab === 'standings'" class="space-y-4">
          <StandingsList :participants="participants" />
        </div>

        <!-- Matches Tab -->
        <div v-if="activeTab === 'matches'" class="space-y-4">
          <MatchesList :matches="matches" />
        </div>

        <!-- Rules Tab -->
        <div v-if="activeTab === 'rules'" class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <!-- Scoring Rules -->
          <div class="space-y-4">
            <h3 class="text-lg font-semibold text-theme-text flex items-center gap-2">
              <Icon icon="mdi:format-list-numbered" class="w-5 h-5 text-theme-secondary" />
              Pontuação por Posição
            </h3>
            <div class="bg-theme-surface rounded-md border border-theme-border overflow-hidden">
              <div class="overflow-x-auto custom-scrollbar">
                <table class="w-full text-sm text-left">
                  <thead class="text-xs text-theme-muted uppercase bg-theme-base border-b border-theme-border">
                    <tr>
                      <th class="px-4 py-2 font-medium">Posição</th>
                      <th class="px-4 py-2 font-medium text-right">Pontos</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="scoring in tournament.scorings" :key="scoring.position" class="border-b border-theme-border last:border-0">
                      <td class="px-4 py-2 text-theme-text">{{ scoring.position }}º Lugar</td>
                      <td class="px-4 py-2 text-right font-medium text-theme-secondary">{{ scoring.points > 0 ? '+' : '' }}{{ scoring.points }}</td>
                    </tr>
                    <tr v-if="!tournament.scorings || tournament.scorings.length === 0">
                      <td colspan="2" class="px-4 py-4 text-center text-theme-muted italic">
                        Nenhuma regra de pontuação definida.
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <!-- Achievements -->
          <div class="space-y-4">
            <h3 class="text-lg font-semibold text-theme-text flex items-center gap-2">
              <Icon icon="mdi:trophy-outline" class="w-5 h-5 text-[#e3b341]" />
              Conquistas (Achievements)
            </h3>
            <div class="space-y-3">
              <div v-for="(achievement, index) in tournament.achievements" :key="index" :class="['p-3 rounded-md bg-theme-surface border transition-colors', achievement.points < 0 ? 'border-red-500/30 bg-red-500/5' : 'border-theme-border']">
                <div class="flex justify-between items-start mb-1">
                  <div class="flex items-center gap-1.5">
                    <Icon v-if="achievement.points < 0" icon="mdi:alert-circle-outline" class="w-4 h-4 text-red-400" />
                    <h4 :class="['font-medium text-sm', achievement.points < 0 ? 'text-red-400' : 'text-theme-text']">{{ achievement.title }}</h4>
                  </div>
                  <span :class="['text-xs font-bold px-2 py-0.5 rounded-full', achievement.points < 0 ? 'text-red-400 bg-red-400/10' : 'text-theme-secondary bg-theme-secondary/10']">
                    {{ achievement.points > 0 ? '+' : '' }}{{ achievement.points }} pts
                  </span>
                </div>
                <p class="text-xs text-theme-muted mb-2">{{ achievement.description }}</p>
                <div v-if="achievement.unique_completion" class="flex items-center gap-1 text-[10px] text-[#e3b341] uppercase font-bold tracking-wider">
                  <Icon icon="mdi:star" class="w-3 h-3" />
                  Único por partida
                </div>
              </div>
              <div v-if="!tournament.achievements || tournament.achievements.length === 0" class="p-6 rounded-md bg-theme-surface border border-dashed border-theme-border text-center text-theme-muted text-sm italic">
                Nenhuma conquista cadastrada.
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  height: 8px;
  width: 8px;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: #161b22; /* theme-surface */
  border-radius: 4px;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #30363d; /* theme-border */
  border-radius: 4px;
  border: 2px solid #161b22; /* theme-surface to create padding effect */
}

.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: #8b949e; /* theme-muted */
}

/* Firefox */
.custom-scrollbar {
  scrollbar-width: thin;
  scrollbar-color: #30363d #161b22;
}

@keyframes slide-up {
  from {
    transform: translateY(100%);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.animate-slide-up {
  animation: slide-up 0.2s ease-out;
}
</style>
