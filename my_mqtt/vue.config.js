const { defineConfig } = require('@vue/cli-service');

module.exports = defineConfig({
  lintOnSave: false, // 禁用 ESLint 检查
  transpileDependencies: true,
});