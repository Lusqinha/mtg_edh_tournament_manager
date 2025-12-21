<script setup>
import { Link, usePage, useForm } from '@inertiajs/vue3'
import { Icon } from '@iconify/vue'
import { format } from 'date-fns'
import { ptBR } from 'date-fns/locale'
import { ref, computed } from 'vue'

const props = defineProps({
  profile_user: Object,
  tournament_stats: Array,
  recent_matches: Array
})

const page = usePage()
const isCurrentUser = computed(() => {
  const authUser = page.props.auth.user
  return authUser && String(authUser.id) === String(props.profile_user.id)
})

const showPasswordModal = ref(false)
const showProfileModal = ref(false)

const passwordForm = useForm({
  current_password: '',
  password: '',
  password_confirmation: ''
})

const profileForm = useForm({
  nickname: props.profile_user.nickname
})

const submitPasswordChange = () => {
  passwordForm.put('/profile', {
    onSuccess: () => {
      showPasswordModal.value = false
      passwordForm.reset()
    }
  })
}

const submitProfileChange = () => {
  profileForm.put('/profile', {
    onSuccess: () => {
      showProfileModal.value = false
    }
  })
}

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
    <div class="mb-8 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
      <div class="flex items-center gap-4">
        <div class="w-16 h-16 rounded-full bg-theme-surface border border-theme-border flex items-center justify-center text-theme-muted">
          <Icon icon="mdi:account" class="w-8 h-8" />
        </div>
        <div>
          <h1 class="text-2xl font-bold text-theme-text">{{ profile_user.nickname }}</h1>
          <p class="text-sm text-theme-muted">Membro desde {{ formatDate(profile_user.created_at) }}</p>
        </div>
      </div>

      <div v-if="isCurrentUser" class="flex flex-wrap gap-2 w-full sm:w-auto">
        <button @click="showProfileModal = true" class="flex-1 sm:flex-none flex items-center justify-center gap-2 px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium text-sm hover:bg-github-btn-hover transition-colors border border-theme-border">
          <Icon icon="mdi:pencil" class="w-4 h-4" />
          Editar Perfil
        </button>
        <button @click="showPasswordModal = true" class="flex-1 sm:flex-none flex items-center justify-center gap-2 px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium text-sm hover:bg-github-btn-hover transition-colors border border-theme-border">
          <Icon icon="mdi:lock-reset" class="w-4 h-4" />
          Alterar Senha
        </button>
        <Link href="/session" method="delete" as="button" class="flex-1 sm:flex-none flex items-center justify-center gap-2 px-4 py-2 rounded-md bg-red-500/10 text-red-400 font-medium text-sm hover:bg-red-500/20 transition-colors border border-red-500/20">
          <Icon icon="mdi:logout" class="w-4 h-4" />
          Sair
        </Link>
      </div>
    </div>

    <!-- Profile Modal -->
    <div v-if="showProfileModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-theme-base/80 backdrop-blur-sm">
      <div class="bg-theme-surface rounded-md border border-theme-border shadow-xl w-full max-w-md p-6">
        <h3 class="text-lg font-semibold text-theme-text mb-4">Editar Perfil</h3>
        
        <form @submit.prevent="submitProfileChange" class="space-y-4">
          <div class="space-y-2">
            <label for="nickname" class="text-sm font-semibold text-theme-text">Nickname</label>
            <input v-model="profileForm.nickname" type="text" id="nickname" class="w-full px-3 py-2 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none text-sm" required />
            <div v-if="profileForm.errors.nickname" class="text-[#ff7b72] text-xs">{{ profileForm.errors.nickname }}</div>
          </div>

          <div class="flex gap-3 pt-2">
            <button type="submit" :disabled="profileForm.processing" class="flex-1 py-2 rounded-md bg-theme-primary text-white font-medium hover:bg-github-btn-primary-hover transition-colors cursor-pointer disabled:opacity-50 border border-[rgba(240,246,252,0.1)] shadow-sm text-sm">
              {{ profileForm.processing ? 'Salvando...' : 'Salvar' }}
            </button>
            <button type="button" @click="showProfileModal = false" class="px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium hover:bg-github-btn-hover transition-colors border border-theme-border text-sm">
              Cancelar
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Password Modal -->
    <div v-if="showPasswordModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-theme-base/80 backdrop-blur-sm">
      <div class="bg-theme-surface rounded-md border border-theme-border shadow-xl w-full max-w-md p-6">
        <h3 class="text-lg font-semibold text-theme-text mb-4">Alterar Senha</h3>
        
        <form @submit.prevent="submitPasswordChange" class="space-y-4">
          <div class="space-y-2">
            <label for="current_password" class="text-sm font-semibold text-theme-text">Senha Atual</label>
            <input v-model="passwordForm.current_password" type="password" id="current_password" class="w-full px-3 py-2 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none text-sm" required />
            <div v-if="passwordForm.errors.current_password" class="text-[#ff7b72] text-xs">{{ passwordForm.errors.current_password }}</div>
          </div>

          <div class="space-y-2">
            <label for="password" class="text-sm font-semibold text-theme-text">Nova Senha</label>
            <input v-model="passwordForm.password" type="password" id="password" class="w-full px-3 py-2 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none text-sm" required />
            <div v-if="passwordForm.errors.password" class="text-[#ff7b72] text-xs">{{ passwordForm.errors.password }}</div>
          </div>

          <div class="space-y-2">
            <label for="password_confirmation" class="text-sm font-semibold text-theme-text">Confirmar Nova Senha</label>
            <input v-model="passwordForm.password_confirmation" type="password" id="password_confirmation" class="w-full px-3 py-2 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none text-sm" required />
          </div>

          <div class="flex gap-3 pt-2">
            <button type="submit" :disabled="passwordForm.processing" class="flex-1 py-2 rounded-md bg-theme-primary text-white font-medium hover:bg-github-btn-primary-hover transition-colors cursor-pointer disabled:opacity-50 border border-[rgba(240,246,252,0.1)] shadow-sm text-sm">
              {{ passwordForm.processing ? 'Salvando...' : 'Salvar' }}
            </button>
            <button type="button" @click="showPasswordModal = false" class="px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium hover:bg-github-btn-hover transition-colors border border-theme-border text-sm">
              Cancelar
            </button>
          </div>
        </form>
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
