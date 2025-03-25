import { createRouter, createWebHistory } from 'vue-router'
import HomeSection from '@/layouts/HomeSection.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeSection,
    },
    {
      path: '/features',
      name: 'features',
      component: () => import('@/layouts/FeaturesSection.vue'),
    },
    {
      path: '/pricing',
      name: 'pricing',
      component: () => import('@/layouts/PricingSection.vue'),
    },
    {
      path: '/contact',
      name: 'contact',
      component: () => import('@/layouts/ContactSection.vue'),
    },
  ],
})

export default router
