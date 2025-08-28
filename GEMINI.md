# Gemini Project Configuration for trip-geninus-monorepo

本文件为 `trip-geninus-monorepo` 项目的 AI 协作配置文件，旨在提供项目上下文、规范和常用命令，以确保开发过程的一致性和高效性。

## 1. 项目概览

这是一个基于 npm-workspace 的 monorepo 项目，包含以下几个核心包：

-   **`packages/server`**: Koa + TypeScript 后端服务，负责 API 逻辑和为前端应用提供服务。
-   **`packages/web`**: 面向桌面用户的 Vue 3 + Vite + Element Plus 前端应用。
-   **`packages/mobile`**: 面向移动用户的 Vue 3 + Vite + Vant 前端应用。


## 2. 全局命令

在项目根目录执行以下命令：

-   **安装所有依赖**:
    ```bash
    npm install
    ```
-   **构建所有包**: (此命令会依次构建所有子包，并将前端产物复制到 server 的 public 目录)
    ```bash
    npm run build
    ```
-   **运行所有测试**:
    ```bash
    npm run test
    ```

## 3. 包特定指令

### `packages/server` (后端服务)

-   **技术栈**: Koa.js, TypeScript, Mongoose
-   **启动开发服务**:
    ```bash
    npm run dev -w trip-geninus-server
    ```
-   **构建生产版本**:
    ```bash
    npm run build -w trip-geninus-server
    ```
-   **启动生产服务**:
    ```bash
    npm run start -w trip-geninus-server
    ```

### `packages/web` (桌面端)

-   **技术栈**: Vue 3, Vite, TypeScript, Element Plus, Pinia
-   **启动开发服务**:
    ```bash
    npm run dev -w trip-geninus-web
    ```
-   **构建生产版本**:
    ```bash
    npm run build -w trip-geninus-web
    ```
-   **运行单元测试**:
    ```bash
    npm run test -w trip-geninus-web
    ```

### `packages/mobile` (移动端)

-   **技术栈**: Vue 3, Vite, TypeScript, Vant, Pinia
-   **启动开发服务**:
    ```bash
    npm run dev -w trip-geninus-mobile
    ```
-   **构建生产版本**:
    ```bash
    npm run build -w trip-geninus-mobile
    ```
-   **运行单元测试**:
    ```bash
    npm run test -w trip-geninus-mobile
    ```

## 4. 编码与架构规范

-   **语言**: 所有包都必须使用 TypeScript。
-   **代码风格**: 遵循各包中已配置的 `.prettierrc.json` 和 `eslint.config.ts` 规范。
-   **Vue**:
    -   所有新组件必须使用 `<script setup>` 语法。
    -   状态管理统一使用 Pinia。
-   **后端**:
    -   严格遵循 `controller` -> `service` -> `schema` 的分层架构。
    -   所有数据库 ObjectId 必须经过 `validateObjectId` 校验。
-   **Table 解析库**:
    -   开发必须遵循 `packages/table/doc/浏览器纯文本转表格解析库规范.md` 中定义的流程和细节。

## 5. Git 提交流程

-   **Commit 消息**: 请遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范。
-   **格式**: `<type>(<scope>): <subject>`
    -   `scope` 必须是发生变更的包名（如 `web`, `server` 等）。
-   **示例**:
    -   `feat(web): add user profile page`
    -   `fix(server): correct authentication token expiration logic`

## 6. 代理交互指南

### 6.1. 代理修改文件的尺寸限制

为确保稳定可靠的操作，特别是当代理需要通过写入或替换大量内容来修改文件时，建议将此类文件的大小控制在以下限制内：

*   **最大行数**：500 行
*   **最大文本内容**：20KB

超出这些限制的文件可能会导致代理的内部处理变得不稳定，从而导致执行写入操作时反复失败。对于此类文件，可能需要手动干预（复制粘贴代理提供的内容 。

**注意**：代理通常可以读取更大的文件而不会出现问题。此限制主要适用于代理需要**写入**的文件。

**未来改进**：考虑实施预提交钩子（pre-commit hook）或 CI/CD 检查，以在代理预期修改的文件超出这些尺寸限制时自动提醒开发人员。