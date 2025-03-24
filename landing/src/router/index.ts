import { createRouter, createWebHistory } from 'vue-router'
import HomeSection from '@/components/landing/HomeSection.vue'

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
      component: () => import('@/components/landing/FeaturesSection.vue'),
    },
    {
      path: '/pricing',
      name: 'pricing',
      component: () => import('@/components/landing/PricingSection.vue'),
    },
    {
      path: '/contact',
      name: 'contact',
      component: () => import('@/components/landing/ContactSection.vue'),
    },
  ],
})

export default router
