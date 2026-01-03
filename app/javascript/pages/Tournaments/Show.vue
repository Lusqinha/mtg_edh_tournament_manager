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
  available_users: Array,
  statistics: Object
})

const showAddPlayerModal = ref(false)
const showMatchTypeModal = ref(false)
const showOrganizersModal = ref(false)
const activeTab = ref('standings') // standings, matches, rules, statistics

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

const formatDuration = (seconds) => {
  if (!seconds) return '-'
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  if (hours > 0) return `${hours}h ${minutes}m`
  return `${minutes}m`
}
</script>

<template>
  <div class="max-w-5xl mx-auto px-4 py-8">
    <div class="mb-8">
      <!-- Header with title and action icons -->
      <div class="flex items-center justify-between mb-6">
        <div class="flex items-center gap-3">
          <Link href="/tournaments" class="p-1.5 rounded-md hover:bg-github-btn-bg transition-colors text-theme-muted hover:text-theme-secondary">
            <Icon icon="mdi:arrow-left" class="w-5 h-5" />
          </Link>
          <div>
            <h1 class="text-xl font-semibold text-theme-text">{{ tournament.name }}</h1>
            <p class="text-xs text-theme-muted">Organizado por {{ tournament.created_by.nickname }}</p>
          </div>
        </div>

        <!-- Action icons (only for organizers) -->
        <div v-if="tournament.is_organizer" class="flex items-center gap-1">
          <button
            @click="showAddPlayerModal = true"
            class="p-2 rounded-md hover:bg-github-btn-bg text-theme-muted hover:text-theme-text transition-colors"
            title="Adicionar Jogador"
          >
            <Icon icon="mdi:account-plus" class="w-5 h-5" />
          </button>

          <button
            v-if="tournament.invite_code"
            @click="copyInviteLink"
            class="p-2 rounded-md hover:bg-github-btn-bg text-theme-muted hover:text-theme-text transition-colors"
            title="Copiar Link de Convite"
          >
            <Icon icon="mdi:share-variant" class="w-5 h-5" />
          </button>

          <Link
            :href="`/tournaments/${tournament.slug}/edit`"
            class="p-2 rounded-md hover:bg-github-btn-bg text-theme-muted hover:text-theme-text transition-colors"
            title="Editar Torneio"
          >
            <Icon icon="mdi:pencil" class="w-5 h-5" />
          </Link>
        </div>
      </div>

      <!-- Action buttons row -->
      <div v-if="tournament.is_organizer || tournament.is_participant" class="flex gap-3 mb-8 overflow-x-auto pb-2 custom-scrollbar">
        <button @click="showMatchTypeModal = true" class="flex items-center gap-2 px-4 py-2 rounded-md bg-theme-primary text-white font-medium text-sm hover:bg-github-btn-primary-hover transition-colors whitespace-nowrap border border-[rgba(240,246,252,0.1)] shadow-sm cursor-pointer">
          <Icon icon="mdi:sword-cross" class="w-4 h-4" />
          <span>Registrar Partida</span>
        </button>

        <button v-if="tournament.is_owner" @click="showOrganizersModal = true" class="flex items-center gap-2 px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium text-sm hover:bg-github-btn-hover transition-colors whitespace-nowrap border border-theme-border cursor-pointer">
          <Icon icon="mdi:account-group" class="w-4 h-4" />
          <span>Organizadores</span>
        </button>
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

      <!-- Organizers Modal -->
      <div v-if="showOrganizersModal" class="fixed inset-0 z-50 flex items-end sm:items-center justify-center p-0 sm:p-4 bg-theme-base/80 backdrop-blur-sm" @click.self="showOrganizersModal = false">
        <div class="bg-theme-surface rounded-t-xl sm:rounded-xl border border-theme-border shadow-xl w-full sm:max-w-md overflow-hidden animate-slide-up sm:animate-none max-h-[85vh] flex flex-col">
          <div class="p-4 border-b border-theme-border shrink-0">
            <div class="flex items-center justify-between">
              <h3 class="text-lg font-semibold text-theme-text flex items-center gap-2">
                <Icon icon="mdi:account-group" class="w-5 h-5 text-theme-secondary" />
                Organizadores
              </h3>
              <button @click="showOrganizersModal = false" class="p-1 rounded-md hover:bg-github-btn-bg text-theme-muted hover:text-theme-text transition-colors">
                <Icon icon="mdi:close" class="w-5 h-5" />
              </button>
            </div>
            <p class="text-sm text-theme-muted mt-1">Organizadores podem registrar partidas e adicionar jogadores.</p>
          </div>
          
          <div class="p-4 overflow-y-auto flex-1">
            <!-- Current Organizers -->
            <div class="space-y-2 mb-6">
              <h4 class="text-xs font-medium text-theme-muted uppercase tracking-wider mb-2">Organizadores Atuais</h4>
              <div v-for="organizer in tournament.organizers" :key="organizer.id" class="flex items-center justify-between p-3 rounded-lg bg-theme-base border border-theme-border">
                <div class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-full bg-theme-surface border border-theme-border overflow-hidden flex items-center justify-center shrink-0">
                    <img v-if="organizer.avatar_url" :src="organizer.avatar_url" :alt="organizer.nickname" class="w-full h-full object-cover" />
                    <Icon v-else icon="mdi:account" class="w-4 h-4 text-theme-muted" />
                  </div>
                  <div>
                    <span class="font-medium text-theme-text text-sm">{{ organizer.nickname }}</span>
                    <span v-if="organizer.is_owner" class="ml-2 text-[10px] bg-[#e3b341]/20 text-[#e3b341] px-1.5 py-0.5 rounded-full font-medium">
                      Criador
                    </span>
                  </div>
                </div>
                <Link
                  v-if="!organizer.is_owner"
                  :href="`/tournaments/${tournament.slug}/organizers/${organizer.id}`"
                  method="delete"
                  as="button"
                  class="p-1.5 rounded-md text-red-400 hover:bg-red-500/10 transition-colors"
                >
                  <Icon icon="mdi:close" class="w-4 h-4" />
                </Link>
              </div>
            </div>

            <!-- Add Organizer -->
            <div class="border-t border-theme-border pt-4">
              <h4 class="text-xs font-medium text-theme-muted uppercase tracking-wider mb-2">Promover Participante</h4>
              <div class="space-y-2">
                <Link
                  v-for="participant in participants.filter(p => !tournament.organizers.some(o => o.nickname === p.user.nickname))"
                  :key="participant.user.nickname"
                  :href="`/tournaments/${tournament.slug}/organizers`"
                  method="post"
                  :data="{ user_id: participant.user_id }"
                  as="button"
                  class="w-full flex items-center justify-between p-3 rounded-lg bg-theme-base border border-theme-border hover:border-theme-secondary hover:bg-theme-secondary/5 transition-colors"
                >
                  <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-full bg-theme-surface border border-theme-border overflow-hidden flex items-center justify-center shrink-0">
                      <img v-if="participant.user.avatar_url" :src="participant.user.avatar_url" :alt="participant.user.nickname" class="w-full h-full object-cover" />
                      <Icon v-else icon="mdi:account" class="w-4 h-4 text-theme-muted" />
                    </div>
                    <span class="text-theme-text text-sm">{{ participant.user.nickname }}</span>
                  </div>
                  <Icon icon="mdi:plus" class="w-4 h-4 text-theme-secondary" />
                </Link>
                <div v-if="participants.filter(p => !tournament.organizers.some(o => o.nickname === p.user.nickname)).length === 0" class="p-4 text-center text-sm text-theme-muted italic">
                  Todos os participantes já são organizadores.
                </div>
              </div>
            </div>
          </div>

          <div class="p-4 border-t border-theme-border sm:hidden shrink-0">
            <button @click="showOrganizersModal = false" class="w-full py-2.5 rounded-md bg-github-btn-bg text-theme-text font-medium hover:bg-github-btn-hover transition-colors border border-theme-border text-sm">
              Fechar
            </button>
          </div>
        </div>
      </div>

      <!-- Tabs -->
      <div class="border-b border-theme-border mb-6 overflow-x-auto overflow-y-hidden custom-scrollbar">
        <nav class="-mb-px flex space-x-6" aria-label="Tabs">
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
          <button @click="activeTab = 'statistics'" :class="[activeTab === 'statistics' ? 'border-theme-secondary text-theme-secondary' : 'border-transparent text-theme-muted hover:text-theme-text hover:border-theme-muted', 'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm flex items-center gap-2']">
            <Icon icon="mdi:chart-bar" class="w-4 h-4" />
            <span class="hidden sm:inline">Estatísticas</span>
            <span class="sm:hidden">Stats</span>
          </button>
          <button @click="activeTab = 'rules'" :class="[activeTab === 'rules' ? 'border-theme-secondary text-theme-secondary' : 'border-transparent text-theme-muted hover:text-theme-text hover:border-theme-muted', 'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm flex items-center gap-2']">
            <Icon icon="mdi:book-open-variant" class="w-4 h-4" />
            <span class="hidden sm:inline">Regras</span>
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

        <!-- Statistics Tab -->
        <div v-if="activeTab === 'statistics'" class="space-y-6">
          <!-- Overview Cards -->
          <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
            <div class="bg-theme-surface rounded-lg border border-theme-border p-4 text-center">
              <div class="text-2xl font-bold text-theme-secondary">{{ statistics?.overview?.total_matches || 0 }}</div>
              <div class="text-xs text-theme-muted mt-1">Partidas</div>
            </div>
            <div class="bg-theme-surface rounded-lg border border-theme-border p-4 text-center">
              <div class="text-2xl font-bold text-theme-secondary">{{ statistics?.overview?.total_participants || 0 }}</div>
              <div class="text-xs text-theme-muted mt-1">Participantes</div>
            </div>
            <div class="bg-theme-surface rounded-lg border border-theme-border p-4 text-center">
              <div class="text-2xl font-bold text-[#e3b341]">{{ statistics?.overview?.total_points_distributed || 0 }}</div>
              <div class="text-xs text-theme-muted mt-1">Pontos</div>
            </div>
            <div class="bg-theme-surface rounded-lg border border-theme-border p-4 text-center">
              <div class="text-2xl font-bold text-theme-text">{{ formatDuration(statistics?.overview?.average_match_duration) }}</div>
              <div class="text-xs text-theme-muted mt-1">Duração Média</div>
            </div>
          </div>

          <div class="grid md:grid-cols-2 gap-6">
            <!-- Top Winners -->
            <div class="bg-theme-surface rounded-lg border border-theme-border overflow-hidden">
              <div class="px-4 py-3 border-b border-theme-border bg-theme-base">
                <h2 class="font-semibold text-theme-text flex items-center gap-2 text-sm">
                  <Icon icon="mdi:trophy" class="w-4 h-4 text-[#e3b341]" />
                  Mais Vitórias
                </h2>
              </div>
              <div class="divide-y divide-theme-border">
                <div v-for="(player, index) in (statistics?.top_winners || [])" :key="index" class="px-4 py-3 flex items-center gap-3">
                  <div class="w-7 h-7 rounded-full bg-theme-base border border-theme-border overflow-hidden flex items-center justify-center shrink-0">
                    <img v-if="player.avatar_url" :src="player.avatar_url" :alt="player.nickname" class="w-full h-full object-cover" />
                    <Icon v-else icon="mdi:account" class="w-3 h-3 text-theme-muted" />
                  </div>
                  <div class="flex-1 min-w-0">
                    <span class="font-medium text-theme-text truncate block text-sm">{{ player.nickname }}</span>
                  </div>
                  <div class="text-lg font-bold text-[#e3b341]">{{ player.wins }}</div>
                </div>
                <div v-if="!statistics?.top_winners?.length" class="px-4 py-6 text-center text-theme-muted text-sm">
                  Nenhuma vitória registrada.
                </div>
              </div>
            </div>

            <!-- Participation Ranking -->
            <div class="bg-theme-surface rounded-lg border border-theme-border overflow-hidden">
              <div class="px-4 py-3 border-b border-theme-border bg-theme-base">
                <h2 class="font-semibold text-theme-text flex items-center gap-2 text-sm">
                  <Icon icon="mdi:cards-playing" class="w-4 h-4 text-theme-secondary" />
                  Mais Participações
                </h2>
              </div>
              <div class="divide-y divide-theme-border">
                <div v-for="(player, index) in (statistics?.participation_ranking || [])" :key="index" class="px-4 py-3 flex items-center gap-3">
                  <div class="w-7 h-7 rounded-full bg-theme-base border border-theme-border overflow-hidden flex items-center justify-center shrink-0">
                    <img v-if="player.avatar_url" :src="player.avatar_url" :alt="player.nickname" class="w-full h-full object-cover" />
                    <Icon v-else icon="mdi:account" class="w-3 h-3 text-theme-muted" />
                  </div>
                  <div class="flex-1 min-w-0">
                    <span class="font-medium text-theme-text truncate block text-sm">{{ player.nickname }}</span>
                  </div>
                  <div class="text-lg font-bold text-theme-secondary">{{ player.matches_played }}</div>
                </div>
                <div v-if="!statistics?.participation_ranking?.length" class="px-4 py-6 text-center text-theme-muted text-sm">
                  Nenhuma participação registrada.
                </div>
              </div>
            </div>
          </div>
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
              Conquistas
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
