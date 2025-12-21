<script setup>
import { Link, useForm } from '@inertiajs/vue3'
import { ref } from 'vue'
import { Icon } from '@iconify/vue'

const props = defineProps({
  tournament: Object,
  participants: Array,
  matches: Array,
  available_users: Array
})

const showAddPlayerModal = ref(false)
const activeTab = ref('standings') // standings, matches, rules

const addPlayerForm = useForm({
  user_id: ''
})

const submitAddPlayer = () => {
  addPlayerForm.post(`/tournaments/${props.tournament.id}/participants`, {
    onSuccess: () => {
      showAddPlayerModal.value = false
      addPlayerForm.reset()
    }
  })
}

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

      <div v-if="tournament.is_organizer" class="flex gap-3 mb-8 overflow-x-auto pb-2">
        <Link :href="`/tournaments/${tournament.id}/matches/new`" class="flex items-center gap-2 px-4 py-2 rounded-md bg-theme-primary text-white font-medium text-sm hover:bg-github-btn-primary-hover transition-colors whitespace-nowrap border border-[rgba(240,246,252,0.1)] shadow-sm">
          <Icon icon="mdi:sword-cross" class="w-4 h-4" />
          Iniciar Partida
        </Link>
        
        <button @click="showAddPlayerModal = true" class="flex items-center gap-2 px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium text-sm hover:bg-github-btn-hover transition-colors whitespace-nowrap border border-theme-border cursor-pointer">
          <Icon icon="mdi:account-plus" class="w-4 h-4" />
          Adicionar Jogador
        </button>

        <Link :href="`/tournaments/${tournament.id}/edit`" class="flex items-center gap-2 px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium text-sm hover:bg-github-btn-hover transition-colors whitespace-nowrap border border-theme-border">
          <Icon icon="mdi:pencil" class="w-4 h-4" />
          Editar Torneio
        </Link>
      </div>

      <!-- Add Player Modal -->
      <div v-if="showAddPlayerModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-theme-base/80 backdrop-blur-sm">
        <div class="bg-theme-surface rounded-md border border-theme-border shadow-xl w-full max-w-md p-6">
          <h3 class="text-lg font-semibold text-theme-text mb-4">Adicionar Jogador</h3>
          
          <form @submit.prevent="submitAddPlayer" class="space-y-4">
            <div class="space-y-2">
              <label for="user_id" class="text-sm font-semibold text-theme-text">Selecione o Jogador</label>
              <select id="user_id" v-model="addPlayerForm.user_id" class="w-full px-3 py-2 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none appearance-none text-sm" required>
                <option value="" disabled>Selecione um jogador...</option>
                <option v-for="user in available_users" :key="user.id" :value="user.id">
                  {{ user.nickname }}
                </option>
              </select>
              <div v-if="addPlayerForm.errors.user_id" class="text-[#ff7b72] text-xs">{{ addPlayerForm.errors.user_id }}</div>
            </div>

            <div class="flex gap-3 pt-2">
              <button type="submit" :disabled="addPlayerForm.processing" class="flex-1 py-2 rounded-md bg-theme-primary text-white font-medium hover:bg-github-btn-primary-hover transition-colors cursor-pointer disabled:opacity-50 border border-[rgba(240,246,252,0.1)] shadow-sm text-sm">
                {{ addPlayerForm.processing ? 'Adicionando...' : 'Adicionar' }}
              </button>
              <button type="button" @click="showAddPlayerModal = false" class="px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium hover:bg-github-btn-hover transition-colors border border-theme-border text-sm">
                Cancelar
              </button>
            </div>
          </form>
        </div>
      </div>

      <!-- Tabs -->
      <div class="border-b border-theme-border mb-6">
        <nav class="-mb-px flex space-x-8" aria-label="Tabs">
          <button @click="activeTab = 'standings'" :class="[activeTab === 'standings' ? 'border-theme-secondary text-theme-secondary' : 'border-transparent text-theme-muted hover:text-theme-text hover:border-theme-muted', 'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm flex items-center gap-2']">
            <Icon icon="mdi:podium" class="w-4 h-4" />
            Classificação
          </button>
          <button @click="activeTab = 'matches'" :class="[activeTab === 'matches' ? 'border-theme-secondary text-theme-secondary' : 'border-transparent text-theme-muted hover:text-theme-text hover:border-theme-muted', 'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm flex items-center gap-2']">
            <Icon icon="mdi:flash" class="w-4 h-4" />
            Partidas
          </button>
          <button @click="activeTab = 'rules'" :class="[activeTab === 'rules' ? 'border-theme-secondary text-theme-secondary' : 'border-transparent text-theme-muted hover:text-theme-text hover:border-theme-muted', 'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm flex items-center gap-2']">
            <Icon icon="mdi:book-open-variant" class="w-4 h-4" />
            Regras e Pontuação
          </button>
        </nav>
      </div>

      <!-- Content -->
      <div>
        <!-- Standings Tab -->
        <div v-if="activeTab === 'standings'" class="space-y-4">
          <div class="bg-theme-surface rounded-md border border-theme-border overflow-hidden">
            <div class="overflow-x-auto">
              <table class="w-full text-sm text-left">
                <thead class="text-xs text-theme-muted uppercase bg-theme-base border-b border-theme-border">
                  <tr>
                    <th class="px-6 py-3 font-medium">Pos</th>
                    <th class="px-6 py-3 font-medium">Jogador</th>
                    <th class="px-6 py-3 font-medium text-center">Partidas</th>
                    <th class="px-6 py-3 font-medium text-center">Vitórias</th>
                    <th class="px-6 py-3 font-medium text-center">Win Rate</th>
                    <th class="px-6 py-3 font-medium text-right">Pontos</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(participant, index) in participants" :key="index" class="border-b border-theme-border last:border-0 hover:bg-github-btn-bg/50 transition-colors">
                    <td class="px-6 py-4">
                      <div :class="['w-6 h-6 flex items-center justify-center rounded-full font-bold text-xs', index === 0 ? 'bg-[#e3b341]/20 text-[#e3b341]' : (index === 1 ? 'bg-theme-muted/20 text-theme-muted' : (index === 2 ? 'bg-[#d29922]/20 text-[#d29922]' : 'bg-theme-border/50 text-theme-muted'))]">
                        {{ index + 1 }}
                      </div>
                    </td>
                    <td class="px-6 py-4 font-medium text-theme-text">{{ participant.user.nickname }}</td>
                    <td class="px-6 py-4 text-center text-theme-muted">{{ participant.matches_played }}</td>
                    <td class="px-6 py-4 text-center text-theme-muted">{{ participant.wins }}</td>
                    <td class="px-6 py-4 text-center text-theme-muted">{{ participant.win_rate }}%</td>
                    <td class="px-6 py-4 text-right font-bold text-theme-secondary">{{ participant.score }}</td>
                  </tr>
                  <tr v-if="participants.length === 0">
                    <td colspan="6" class="px-6 py-8 text-center text-theme-muted">
                      Nenhum participante registrado ainda.
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- Matches Tab -->
        <div v-if="activeTab === 'matches'" class="space-y-4">
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
