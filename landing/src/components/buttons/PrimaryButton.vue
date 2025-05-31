<template>
  <component
    :is="primary ? RouterLink : 'button'"
    :to="primary ? '/register' : undefined"
    @click="!primary && scrollAndClose('pricing')"
    :class="[
      'btn btn-lg font-semibold px-6 py-3 rounded-lg transition cursor-pointer border-none',
      primary
        ? 'bg-primary-500 text-white hover:bg-primary-700'
        : 'bg-secondary-300 text-white hover:bg-secondary-400'
    ]"
    :aria-label="label"
  >
    <slot />
  </component>
</template>

<script setup>
import { RouterLink } from 'vue-router';

defineEmits(['scrollTo']);

const scrollAndClose = (sectionId) => {
  document.getElementById(sectionId)?.scrollIntoView({ behavior: 'smooth' });
};

defineProps({
  primary: Boolean,
  label: String,
});
</script>
