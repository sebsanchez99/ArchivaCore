<template>
    <div class="h-screen w-screen bg-gray-100 flex items-center">
        <div class="container flex flex-col md:flex-row items-center justify-center px-5 text-gray-700">
            <div class="max-w-md">
                <div class="text-5xl font-dark font-bold text-secondary-500">404</div>
                <p
                  class="text-2xl md:text-3xl font-light leading-normal"
                >Lo sentimos, no pudimos encontrar esta página. </p>
                <p class="mb-8">Pero no se preocupe, puede encontrar muchas otras cosas en nuestra página de inicio.</p>
    
                <RouterLink to="/" replace>
                    <button class="cursor-pointer px-4 inline py-2 text-sm font-medium leading-5 shadow text-white transition-colors duration-150 border border-transparent rounded-lg focus:outline-none focus:shadow-outline-blue bg-primary-500 active:bg-primary-600 hover:bg-primary-600">
                    Regresar a inicio
                    </button>
                </RouterLink>
            </div>
          <div class="max-w-lg">
          <img src="@/assets/logo.png" class="w-60 h-auto">
        </div>
    
      </div>
    </div>
</template>