<template>
    <div class="flex flex-col h-screen">
      <!-- Header -->
      <NavBarSection/>
      <!-- Fin Header -->
  
      <!-- Main -->
      <main class="flex-1 flex-col items-center justify-center py-6">
        <HomeSection/>
        <FeaturesSection/>
        <PricingSection/>
      </main>
      <!-- Fin Main -->
  
      <!-- Footer -->
      <ContactSection/>
      <!-- Fin Footer -->
    </div>
  </template>
  
  <script lang="ts" setup>
  import HomeSection from "@/components/landing/HomeSection.vue";
  import NavBarSection from "@/components/landing/NavBarSection.vue";
  import FeaturesSection from "@/components/landing/FeaturesSection.vue";
  import PricingSection from "@/components/landing/PricingSection.vue";
  import ContactSection from "@/components/landing/ContactSection.vue";
  </script>
  