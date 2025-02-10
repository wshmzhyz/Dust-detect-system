// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import App from './App'
import router from './router' //引入vue-router
import ElementUI from 'element-ui';             //全局引入element
import 'element-ui/lib/theme-chalk/index.css';    //全局引入element的样式
import '../static/fonts/iconfont.css';


Vue.config.productionTip = false
Vue.use(ElementUI);     //全局注入element
new Vue({
  render: h => h(App),
  router,
  beforeCreate() {
    Vue.prototype.$bus = this;//安装全局事件总线
  }
}).$mount('#app')
