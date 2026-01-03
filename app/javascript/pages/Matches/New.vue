<script setup>
import { useForm, Link } from '@inertiajs/vue3'
import { Icon } from '@iconify/vue'

const props = defineProps({
  tournament: Object,
  participants: Array
})

const form = useForm({
  player_ids: []
})

const submit = () => {
  form.post(`/tournaments/${props.tournament.slug}/matches`)
}
</script>

<template>
  <div class="max-w-2xl mx-auto px-4 py-8">
    <div class="mb-8">
      <h1 class="text-2xl font-semibold text-theme-text mb-2">Iniciar Nova Partida</h1>
      <p class="text-theme-muted">Selecione os jogadores que participarão desta partida.</p>
    </div>

    <div class="bg-theme-surface rounded-md border border-theme-border p-6 shadow-sm">
      <form @submit.prevent="submit" class="space-y-6">
        <div class="space-y-3">
          <label class="block text-sm font-semibold text-theme-text">Jogadores Disponíveis</label>
          
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div v-for="user in participants" :key="user.id" class="relative">
              <input 
                type="checkbox" 
                :id="`player_${user.id}`" 
                :value="user.id" 
                v-model="form.player_ids"
                class="peer sr-only"
              >
              <label :for="`player_${user.id}`" class="flex items-center gap-3 p-3 rounded-md bg-theme-base border border-theme-border cursor-pointer transition-all hover:border-theme-muted peer-checked:bg-theme-secondary/10 peer-checked:border-theme-secondary peer-checked:text-theme-text text-theme-muted">
                <div class="w-4 h-4 rounded border border-theme-border flex items-center justify-center peer-checked:border-theme-secondary peer-checked:bg-theme-secondary transition-all">
                  <Icon icon="mdi:check" class="w-3 h-3 text-white opacity-0 peer-checked:opacity-100" />
                </div>
                <span class="font-medium text-sm">{{ user.nickname }}</span>
              </label>
            </div>
          </div>
          
          <div v-if="participants.length === 0" class="text-center p-8 border border-dashed border-theme-border rounded-md text-theme-muted">
            Nenhum jogador disponível para selecionar.
          </div>
          <div v-if="form.errors.player_ids" class="text-[#ff7b72] text-sm">{{ form.errors.player_ids }}</div>
        </div>

        <div class="flex flex-col sm:flex-row gap-3 pt-4 border-t border-theme-border">
          <button type="submit" :disabled="form.processing" class="flex-1 py-2 px-4 rounded-md bg-theme-primary text-white font-medium hover:bg-github-btn-primary-hover transition-colors border border-[rgba(240,246,252,0.1)] shadow-sm disabled:opacity-50 disabled:cursor-not-allowed text-sm">
            {{ form.processing ? 'Iniciando...' : 'Iniciar Partida' }}
          </button>
          <Link :href="`/tournaments/${tournament.slug}`" class="px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium hover:bg-github-btn-hover transition-colors border border-theme-border text-center text-sm">
            Cancelar
          </Link>
        </div>
      </form>
    </div>
  </div>
</template>
