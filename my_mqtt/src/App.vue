<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: "app",
};
</script>

<style>
#app {
  overflow: hidden;
  height: 100vh;
}
.icon,
.iconfont {
  font-family: "iconfont" !important;
  font-size: 30px;
  font-style: normal;
  color: #1989fa;
  -webkit-font-smoothing: antialiased;
  -webkit-text-stroke-width: 0.2px;
  -moz-osx-font-smoothing: grayscale;
}
</style>
