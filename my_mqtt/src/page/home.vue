<template>
  <div class="box">
    <el-container class="body">
      <el-aside width="11rem" class="aside">
        <div class="tab">
          <div class="logo">
            <span>员工与区域管理系统</span>
          </div>
          <el-menu
            :collapse-transition="false"
            :default-active="currentIndex"
            class="el-menu-vertical-demo"
            background-color="#f8f8f8"
            text-color="#333"
            active-text-color="#6b52ae"
            @select="handleSelect"
            style="border-right: none"
          >
            <el-menu-item index="1">
              <i class="el-icon-house"></i>
              <span slot="title">区域管理</span>
            </el-menu-item>
            <el-menu-item index="2">
              <i class="el-icon-setting"></i>
              <span slot="title">工人管理</span>
            </el-menu-item>
          </el-menu>
        </div>
      </el-aside>
      <el-container>
        <el-main class="main">
          <router-view class="content"></router-view>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script>
export default {
  name: "home",
  data() {
    return {
      asideWidth: "12rem",
      currentIndex: "1",
    };
  },
  methods: {
    myNotify(type, title, message) {
      this.$notify({
        title: title,
        message: message,
        offset: 100,
        type: type,
        duration: 3000,
      });
    },
    handleSelect(key) {
      if (key === this.currentIndex) return;
      this.currentIndex = key;
      switch (key) {
        case "1":
          this.$router.replace("/areaManager");
          break;
        case "2":
          this.$router.replace("/workerManager");
          break;
      }
    },
  },
};
</script>

<style lang="less" scoped>
@active-color: #6b52ae;
@hover-color: #e0e0e0;
@font-color: white;
@icon-font-size: 1.25rem;
@menu-item-font-size: 1.25rem;
@border-radius: 0.7rem;
@right-margin: 0.625rem;
@header-height: 4rem;
@transition-duration: 0.3s;
@menu-border: 0.8rem;

* {
  margin: 0;
  padding: 0;
}

.box {
  display: flex;
  flex-direction: column;
  height: 100vh;
  width: 100vw;

  .body {
    flex: 1;
  }

  .aside {
    background-color: #f8f8f8;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center;
    transition: width @transition-duration;
    border-radius: 0 @menu-border @menu-border 0;

    .tab {
      width: 100%;
      height: 90%;
      display: flex;
      flex-direction: column;
      align-items: center;

      .logo {
        display: flex;
        justify-content: center;
        align-items: center;
        height: @header-height;

        span {
          font-size: 1.2rem;
          font-family: "Comic Sans MS", "Segoe Script", cursive;
          font-weight: 700;
        }
      }

      .el-menu-vertical-demo {
        width: 100%;
        border-right: none;
        display: flex;
        flex-direction: column;
        align-items: center;

        .el-menu-item {
          outline: none !important; // 移除 outline
          width: 94%;
          height: 3.2rem;
          font-size: @menu-item-font-size;
          display: flex;
          align-items: center;
          border-radius: @border-radius !important;

          /deep/.el-icon {
            width: 2rem !important;
            height: 2rem !important;
            font-size: @icon-font-size !important;
          }

          &.is-active {
            padding-left: 1.25rem;
            background-color: @active-color !important;
            color: @font-color !important;
            border-radius: @border-radius !important;

            .el-icon {
              color: @font-color !important;
            }
          }

          &:hover {
            background-color: @hover-color !important;
            border-radius: @border-radius !important;
          }
        }
      }
    }
  }

  .main {
    padding: 0 !important;
    .content {
      margin: 0;
      padding: 0;
      height: 100%;
      width: 100%;
    }
  }
}
</style>