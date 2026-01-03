<script setup>
import { ref, computed } from 'vue'
import { useForm } from '@inertiajs/vue3'
import { Icon } from '@iconify/vue'
import logoWhite from '../../../assets/images/logo_white.png'

const dicebearStyles = [
  { id: 'adventurer', name: 'Aventureiro', icon: 'mdi:sword' },
  { id: 'avataaars', name: 'Avataaars', icon: 'mdi:emoticon-happy' },
  { id: 'bottts', name: 'Robôs', icon: 'mdi:robot' },
  { id: 'fun-emoji', name: 'Emojis', icon: 'mdi:emoticon-cool' },
  { id: 'lorelei', name: 'Lorelei', icon: 'mdi:face-woman' },
  { id: 'micah', name: 'Micah', icon: 'mdi:account-circle' },
  { id: 'notionists', name: 'Notionists', icon: 'mdi:draw' },
  { id: 'pixel-art', name: 'Pixel Art', icon: 'mdi:gamepad-variant' },
]

const selectedStyle = ref('adventurer')
const avatarSeeds = ref([])
const selectedAvatarUrl = ref(null)
const isGenerating = ref(false)

const form = useForm({
  avatar_url: ''
})

const getDicebearUrl = (style, seed) => {
  return `https://api.dicebear.com/9.x/${style}/svg?seed=${seed}`
}

const generateRandomSeeds = () => {
  isGenerating.value = true
  avatarSeeds.value = Array.from({ length: 4 }, () => Math.random().toString(36).substring(2, 10))
  selectedAvatarUrl.value = null
  setTimeout(() => { isGenerating.value = false }, 300)
}

const selectAvatar = (url) => {
  selectedAvatarUrl.value = url
}

const submit = () => {
  form.avatar_url = selectedAvatarUrl.value
  form.post('/choose_avatar')
}

const skip = () => {
  window.location.href = '/'
}

// Generate initial seeds
generateRandomSeeds()
</script>

<template>
  <div class="min-h-screen flex items-center justify-center p-4 bg-theme-base">
    <div class="w-full max-w-lg p-8 rounded-3xl bg-theme-surface border border-theme-border shadow-2xl">
      <div class="text-center mb-8">
        <img :src="logoWhite" alt="Liga Mesão" class="h-16 w-auto mx-auto mb-4" />
        <h1 class="text-2xl font-bold text-theme-secondary">Escolha seu Avatar</h1>
        <p class="text-theme-muted mt-2 text-sm">Personalize seu perfil com um avatar único!</p>
      </div>

      <!-- Style Selector -->
      <div class="mb-6">
        <label class="text-sm font-medium text-theme-muted mb-3 block">Estilo</label>
        <div class="grid grid-cols-4 gap-2">
          <button
            v-for="style in dicebearStyles"
            :key="style.id"
            @click="selectedStyle = style.id; generateRandomSeeds()"
            :class="[
              'flex flex-col items-center gap-1 p-2 rounded-lg border transition-all text-xs',
              selectedStyle === style.id
                ? 'bg-theme-secondary/10 border-theme-secondary text-theme-secondary'
                : 'bg-theme-base border-theme-border text-theme-muted hover:border-theme-muted'
            ]"
          >
            <Icon :icon="style.icon" class="w-5 h-5" />
            <span class="truncate w-full text-center">{{ style.name }}</span>
          </button>
        </div>
      </div>

      <!-- Avatar Options -->
      <div class="mb-6">
        <div class="flex items-center justify-between mb-3">
          <label class="text-sm font-medium text-theme-muted">Escolha um avatar</label>
          <button
            @click="generateRandomSeeds"
            :disabled="isGenerating"
            class="flex items-center gap-1 text-xs text-theme-secondary hover:text-theme-secondary/80 transition-colors disabled:opacity-50"
          >
            <Icon icon="mdi:refresh" :class="['w-4 h-4', isGenerating ? 'animate-spin' : '']" />
            Gerar novos
          </button>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <button
            v-for="seed in avatarSeeds"
            :key="seed"
            @click="selectAvatar(getDicebearUrl(selectedStyle, seed))"
            :class="[
              'aspect-square rounded-xl border-2 overflow-hidden transition-all p-3 bg-theme-base',
              selectedAvatarUrl === getDicebearUrl(selectedStyle, seed)
                ? 'border-theme-secondary ring-2 ring-theme-secondary/30 scale-105'
                : 'border-theme-border hover:border-theme-muted'
            ]"
          >
            <img
              :src="getDicebearUrl(selectedStyle, seed)"
              alt="Avatar option"
              class="w-full h-full object-contain"
            />
          </button>
        </div>
      </div>

      <!-- Preview -->
      <div v-if="selectedAvatarUrl" class="mb-6 p-4 bg-theme-base rounded-xl border border-theme-border">
        <div class="flex items-center gap-4">
          <div class="w-16 h-16 rounded-full overflow-hidden border-2 border-theme-secondary bg-theme-surface p-1">
            <img :src="selectedAvatarUrl" alt="Preview" class="w-full h-full object-contain" />
          </div>
          <div>
            <p class="text-sm font-medium text-theme-text">Preview do seu avatar</p>
            <p class="text-xs text-theme-muted">É assim que você aparecerá no sistema</p>
          </div>
        </div>
      </div>

      <!-- Actions -->
      <div class="space-y-3">
        <button
          @click="submit"
          :disabled="form.processing || !selectedAvatarUrl"
          class="w-full py-3.5 rounded-xl bg-theme-secondary text-white font-bold shadow-lg hover:opacity-90 transition-all cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {{ form.processing ? 'Salvando...' : 'Confirmar Avatar' }}
        </button>

        <button
          @click="skip"
          class="w-full py-3 rounded-xl bg-theme-base text-theme-muted font-medium hover:bg-theme-border/30 transition-all text-sm"
        >
          Pular por agora
        </button>
      </div>
    </div>
  </div>
</template>

