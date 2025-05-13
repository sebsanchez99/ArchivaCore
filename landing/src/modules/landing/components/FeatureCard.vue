<template>
  <div ref="el" :class="[
    'bg-white shadow rounded-lg p-6 text-center w-full md:w-5/12 lg:w-1/4 transition-all duration-700',
    isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4',
    'hover:scale-[1.03]'
  ]">
    <component :is="iconComponent" class="mx-auto mb-4 text-accent-500 w-10 h-10" aria-hidden="true" />
    <h3 class="text-xl font-bold mb-2 text-primary-800">{{ title }}</h3>
    <p class="text-black">{{ description }}</p>
  </div>
</template>


<script setup>
import { ref, onMounted } from 'vue'
import { h, computed } from 'vue'

const props = defineProps({
  icon: [Function, Object],
  title: String,
  description: String,
})

const iconComponent = computed(() =>
  typeof props.icon === 'function' ? h(props.icon) : props.icon
)

const el = ref(null)
const isVisible = ref(false)

onMounted(() => {
  const observer = new IntersectionObserver(([entry]) => {
    if (entry.isIntersecting) {
      isVisible.value = true
      observer.disconnect()
    }
  }, { threshold: 0.1 })

  if (el.value) observer.observe(el.value)
})
</script>
