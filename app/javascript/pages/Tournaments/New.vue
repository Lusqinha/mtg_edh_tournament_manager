<script setup>
import { useForm, Link } from '@inertiajs/vue3'
import { Icon } from '@iconify/vue'

const form = useForm({
  name: '',
  number_of_rounds: '',
  max_players: ''
})

const submit = () => {
  form.post('/tournaments')
}
</script>

<template>
  <div class="max-w-2xl mx-auto px-4 py-8">
    <div class="flex items-center gap-3 mb-6">
      <Link href="/tournaments" class="p-1.5 rounded-md hover:bg-github-btn-bg transition-colors text-theme-muted hover:text-theme-secondary">
        <Icon icon="mdi:arrow-left" class="w-5 h-5" />
      </Link>
      <h1 class="text-xl font-semibold text-theme-text">Novo Torneio</h1>
    </div>

    <div class="p-6 rounded-md bg-theme-surface border border-theme-border shadow-sm">
      <form @submit.prevent="submit" class="space-y-5">
        <div v-if="Object.keys(form.errors).length > 0" class="p-4 rounded-md bg-red-500/10 border border-red-500/20 text-red-400 text-sm">
          <h2 class="font-semibold mb-2">Por favor corrija os seguintes erros:</h2>
          <ul class="list-disc list-inside space-y-1 opacity-80">
            <li v-for="error in form.errors" :key="error">{{ error }}</li>
          </ul>
        </div>

        <div class="space-y-2">
          <label for="name" class="text-sm font-semibold text-theme-text">Nome do Torneio</label>
          <input v-model="form.name" type="text" id="name" class="w-full px-3 py-2 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text placeholder-theme-muted transition-all outline-none text-sm" required autofocus placeholder="Ex: Liga Commander 2025" />
          <div v-if="form.errors.name" class="text-[#ff7b72] text-xs">{{ form.errors.name }}</div>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div class="space-y-2">
            <label for="number_of_rounds" class="text-sm font-semibold text-theme-text">Número de Rodadas</label>
            <input v-model="form.number_of_rounds" type="number" id="number_of_rounds" class="w-full px-3 py-2 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text placeholder-theme-muted transition-all outline-none text-sm" placeholder="Opcional" />
            <div v-if="form.errors.number_of_rounds" class="text-[#ff7b72] text-xs">{{ form.errors.number_of_rounds }}</div>
          </div>

          <div class="space-y-2">
            <label for="max_players" class="text-sm font-semibold text-theme-text">Máximo de Jogadores</label>
            <input v-model="form.max_players" type="number" id="max_players" class="w-full px-3 py-2 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text placeholder-theme-muted transition-all outline-none text-sm" placeholder="Opcional" />
            <div v-if="form.errors.max_players" class="text-[#ff7b72] text-xs">{{ form.errors.max_players }}</div>
          </div>
        </div>

        <div class="pt-4 flex gap-3">
          <button type="submit" :disabled="form.processing" class="flex-1 py-2 px-4 rounded-md bg-theme-primary text-white font-medium hover:bg-github-btn-primary-hover transition-colors cursor-pointer disabled:opacity-50 border border-[rgba(240,246,252,0.1)] shadow-sm text-sm">
            {{ form.processing ? 'Criando...' : 'Criar Torneio' }}
          </button>
          <Link href="/tournaments" class="px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium hover:bg-github-btn-hover transition-colors text-center border border-theme-border text-sm">
            Cancelar
          </Link>
        </div>
      </form>
    </div>
  </div>
</template>
