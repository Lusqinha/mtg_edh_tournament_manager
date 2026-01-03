<script setup>
import { useForm, Link, usePage } from '@inertiajs/vue3'
import { Icon } from '@iconify/vue'
import { computed } from 'vue'

const props = defineProps({
  tournament: Object,
  participants: Array,
  match_type: {
    type: String,
    default: 'live'
  }
})

const isPastMatch = computed(() => props.match_type === 'past')

// Get current date/time for defaults
const now = new Date()
const formatDateTime = (date) => {
  const pad = (n) => n.toString().padStart(2, '0')
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}T${pad(date.getHours())}:${pad(date.getMinutes())}`
}

const form = useForm({
  player_ids: [],
  match_type: props.match_type,
  started_at: formatDateTime(now),
  ended_at: formatDateTime(now)
})

const submit = () => {
  form.post(`/tournaments/${props.tournament.slug}/matches`)
}
</script>

<template>
  <div class="max-w-2xl mx-auto px-4 py-8">
    <div class="mb-6">
      <div class="flex items-center gap-2 mb-2">
        <div :class="['px-2 py-0.5 rounded-full text-xs font-medium', isPastMatch ? 'bg-theme-secondary/10 text-theme-secondary' : 'bg-theme-primary/10 text-theme-primary']">
          <Icon :icon="isPastMatch ? 'mdi:history' : 'mdi:play-circle'" class="w-3 h-3 inline mr-1" />
          {{ isPastMatch ? 'Partida Passada' : 'Partida ao Vivo' }}
        </div>
      </div>
      <h1 class="text-xl font-semibold text-theme-text">Registrar Partida</h1>
      <p class="text-sm text-theme-muted mt-1">{{ isPastMatch ? 'Informe os dados da partida que já aconteceu.' : 'Selecione os jogadores para iniciar a partida.' }}</p>
    </div>

    <div class="bg-theme-surface rounded-md border border-theme-border p-4 sm:p-6 shadow-sm">
      <form @submit.prevent="submit" class="space-y-6">
        <!-- Time fields for past matches -->
        <div v-if="isPastMatch" class="space-y-4 pb-4 border-b border-theme-border">
          <h3 class="text-sm font-semibold text-theme-text flex items-center gap-2">
            <Icon icon="mdi:clock-outline" class="w-4 h-4 text-theme-muted" />
            Duração da Partida
          </h3>
          
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div class="space-y-2">
              <label for="started_at" class="text-xs font-medium text-theme-muted">Início</label>
              <input 
                type="datetime-local" 
                id="started_at" 
                v-model="form.started_at"
                class="w-full px-3 py-2.5 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none text-sm"
              />
            </div>
            <div class="space-y-2">
              <label for="ended_at" class="text-xs font-medium text-theme-muted">Fim</label>
              <input 
                type="datetime-local" 
                id="ended_at" 
                v-model="form.ended_at"
                class="w-full px-3 py-2.5 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none text-sm"
              />
            </div>
          </div>
        </div>

        <!-- Players selection -->
        <div class="space-y-3">
          <label class="block text-sm font-semibold text-theme-text">Jogadores</label>
          
          <div class="grid grid-cols-2 sm:grid-cols-3 gap-2 sm:gap-3">
            <div v-for="user in participants" :key="user.id" class="relative">
              <input 
                type="checkbox" 
                :id="`player_${user.id}`" 
                :value="user.id" 
                v-model="form.player_ids"
                class="peer sr-only"
              >
              <label :for="`player_${user.id}`" class="flex items-center justify-center gap-2 p-3 rounded-md bg-theme-base border border-theme-border cursor-pointer transition-all hover:border-theme-muted peer-checked:bg-theme-secondary/10 peer-checked:border-theme-secondary text-theme-muted peer-checked:text-theme-text">
                <Icon icon="mdi:check-circle" class="w-4 h-4 hidden peer-checked:block text-theme-secondary" />
                <Icon icon="mdi:account" class="w-4 h-4 peer-checked:hidden" />
                <span class="font-medium text-sm truncate">{{ user.nickname }}</span>
              </label>
            </div>
          </div>
          
          <div v-if="participants.length === 0" class="text-center p-6 border border-dashed border-theme-border rounded-md text-theme-muted text-sm">
            Nenhum jogador disponível.
          </div>
          <div v-if="form.errors.player_ids" class="text-[#ff7b72] text-xs">{{ form.errors.player_ids }}</div>
        </div>

        <div class="flex flex-col-reverse sm:flex-row gap-3 pt-4 border-t border-theme-border">
          <Link :href="`/tournaments/${tournament.slug}`" class="px-4 py-2.5 rounded-md bg-github-btn-bg text-theme-text font-medium hover:bg-github-btn-hover transition-colors border border-theme-border text-center text-sm">
            Cancelar
          </Link>
          <button type="submit" :disabled="form.processing || form.player_ids.length === 0" class="flex-1 py-2.5 px-4 rounded-md bg-theme-primary text-white font-medium hover:bg-github-btn-primary-hover transition-colors border border-[rgba(240,246,252,0.1)] shadow-sm disabled:opacity-50 disabled:cursor-not-allowed text-sm">
            {{ form.processing ? 'Registrando...' : (isPastMatch ? 'Continuar' : 'Iniciar Partida') }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>
