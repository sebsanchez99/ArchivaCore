<template>
  <div class="flex flex-col h-screen">
    <!-- Header -->
    <NavBarSection @scrollTo="scrollTo" />
    <!-- Fin Header -->

    <!-- Main -->
    <main class="flex-1 flex-col items-center justify-center pt-6">
        <HomeSection id="home"/>
        <FeaturesSection id="features"/>
        <PricingSection id="pricing"/>
    </main>
    <!-- Fin Main -->

    <!-- Footer -->
    <ContactSection id="contact" />
    <!-- Fin Footer -->
  </div>
</template>

<script setup>
import HomeSection from "@/modules/landing/layouts/HomeSection.vue"; 
import NavBarSection from "@/modules/landing/layouts/NavBarSection.vue";
import FeaturesSection from "@/modules/landing/layouts/FeaturesSection.vue";
import PricingSection from "@/modules/landing/layouts/PricingSection.vue";
import ContactSection from "@/modules/landing/layouts/ContactSection.vue";

const scrollTo = (sectionId) => {
  const section = document.getElementById(sectionId);
  if (section) {
    section.scrollIntoView({ behavior: "smooth" });
  }
};
</script>
