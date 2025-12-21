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
  <div class="max-w-3xl mx-auto px-4 py-8">
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

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Ranking Section -->
        <div class="lg:col-span-1 space-y-3">
          <h3 class="text-sm font-semibold text-theme-text flex items-center gap-2">
            <Icon icon="mdi:podium" class="w-4 h-4 text-[#e3b341]" />
            Classificação
          </h3>
          
          <div class="bg-theme-surface rounded-md border border-theme-border overflow-hidden">
            <div v-for="(participant, index) in participants" :key="index" class="flex items-center justify-between p-3 border-b border-theme-border last:border-0 hover:bg-github-btn-bg/50 transition-colors">
              <div class="flex items-center gap-3">
                <div :class="['w-6 h-6 flex items-center justify-center rounded-full font-bold text-xs', index === 0 ? 'bg-[#e3b341]/20 text-[#e3b341]' : (index === 1 ? 'bg-theme-muted/20 text-theme-muted' : (index === 2 ? 'bg-[#d29922]/20 text-[#d29922]' : 'bg-theme-border/50 text-theme-muted'))]">
                  {{ index + 1 }}
                </div>
                <span class="font-medium text-theme-text text-sm">{{ participant.user.nickname }}</span>
              </div>
              <span class="font-semibold text-theme-secondary text-sm">{{ participant.score }} pts</span>
            </div>
            <div v-if="participants.length === 0" class="p-6 text-center text-theme-muted text-sm">
              Nenhum participante ainda
            </div>
          </div>
        </div>

        <!-- Matches Section -->
        <div class="lg:col-span-2 space-y-3">
          <h3 class="text-sm font-semibold text-theme-text flex items-center gap-2">
            <Icon icon="mdi:flash" class="w-4 h-4 text-theme-secondary" />
            Partidas Recentes
          </h3>

          <div class="space-y-2">
            <div v-for="match in matches" :key="match.id" class="p-3 rounded-md bg-theme-surface border border-theme-border hover:border-theme-muted transition-all">
              <div class="flex justify-between items-start mb-1">
                <div class="flex items-center gap-2">
                  <span class="text-xs text-theme-muted">Vencedor:</span>
                  <span class="font-semibold text-theme-secondary text-sm">{{ match.winner ? match.winner.nickname : 'Empate' }}</span>
                </div>
                <span class="text-xs text-theme-muted">{{ formatDate(match.created_at) }}</span>
              </div>
              <div class="text-xs text-theme-muted">
                Registrado por {{ match.created_by.nickname }}
              </div>
            </div>
            <div v-if="matches.length === 0" class="p-8 rounded-md bg-theme-surface border border-dashed border-theme-border text-center">
              <p class="text-theme-muted text-sm">Nenhuma partida registrada ainda</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
