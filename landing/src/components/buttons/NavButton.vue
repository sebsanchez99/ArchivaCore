<template>
  <component
    :is="to ? 'RouterLink' : 'button'"
    :to="to"
    :class="[
      'cursor-pointer px-4 py-1.5 rounded text-sm font-semibold transition',
      primary
        ? 'bg-primary-500 text-white hover:bg-primary-600'
        : 'bg-secondary-300 text-white hover:bg-secondary-400'
    ]"
    :aria-label="label"
    @click="handleClick"
  >
    <slot />
  </component>
</template>

<script setup>
import { useRouter } from 'vue-router';

const props = defineProps({
  primary: Boolean,
  label: String,
  to: String
});

const router = useRouter();

const handleClick = () => {
  if (props.to) {
    router.push(props.to);
  }
};
</script>
