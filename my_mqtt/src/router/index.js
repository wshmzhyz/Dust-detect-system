import Vue from "vue";
import Router from "vue-router";
import home from "../page/home";
import workerManager from "../page/workerManager";
import areaManager from "../page/areaManager";

Vue.use(Router);

export default new Router({
    mode: "history",
    routes: [
        {
            path: '/',
            component: home,
            children: [
                {
                    path: '',
                    redirect: 'areaManager'
                },
                {
                    path: 'workerManager',
                    component: workerManager
                },
                {
                    path: 'areaManager',
                    component: areaManager
                }
                ,
            ]
        },
    ]
});