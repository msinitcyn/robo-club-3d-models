# GitHub Actions Setup Instructions

## Первоначальная настройка

### 1. Обновить badge в README.md

Замените в `README.md` строку:
```markdown
![Build STL Files](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/build-stl.yml/badge.svg)
```

На актуальные значения вашего репозитория:
```markdown
![Build STL Files](https://github.com/USERNAME/3d-models/actions/workflows/build-stl.yml/badge.svg)
```

### 2. Настройка permissions для GitHub Actions

Чтобы workflow мог коммитить artifacts обратно в репозиторий:

1. Перейдите в: **Settings** → **Actions** → **General**
2. Найдите раздел **Workflow permissions**
3. Выберите **Read and write permissions**
4. Сохраните изменения

### 3. Первый запуск

После настройки:

```bash
# Добавить новые файлы
git add .github/ .gitignore README.md

# Создать коммит
git commit -m "Add CI/CD pipeline for automatic STL generation"

# Запушить в main (запустится автосборка)
git push origin main
```

Workflow запустится автоматически и:
1. Соберёт все STL файлы
2. Закоммитит их в `artifacts/current/`
3. Создаст GitHub Artifacts на 90 дней

## Проверка работы

### Посмотреть статус сборки

1. Перейдите на вкладку **Actions** в репозитории
2. Найдите последний запуск "Build STL Files"
3. Проверьте, что все шаги зелёные ✓

### Скачать готовые STL

**Из Artifacts:**
1. Actions → последний успешный запуск
2. Внизу страницы: **Artifacts** → `stl-files-current`
3. Скачать zip архив

**Из репозитория:**
1. Перейти в папку `artifacts/current/`
2. Скачать нужные `.stl` файлы

## Создание релиза

Для создания стабильной версии с GitHub Release:

```bash
# Создать тег
git tag -a v1.1 -m "Version 1.1: Description of changes"

# Запушить тег
git push origin v1.1
```

Workflow автоматически:
1. Соберёт все STL
2. Создаст GitHub Release с версией v1.1
3. Прикрепит все STL файлы к релизу
4. Сгенерирует release notes

## Troubleshooting

### Workflow не запускается

- Проверьте, что workflow файл в правильном месте: `.github/workflows/build-stl.yml`
- Проверьте, что в Settings → Actions включены workflows

### Ошибка при коммите artifacts

- Проверьте **Workflow permissions** (должно быть Read and write)
- Проверьте, что ветка `main` не защищена от force push

### OpenSCAD ошибки при сборке

- Проверьте синтаксис в `.scad` файлах локально
- Убедитесь, что все файлы используют `use <common.scad>` а не `include`
- Проверьте логи в Actions для деталей ошибки

## Структура workflow

Workflow состоит из следующих шагов:

1. **Checkout** - клонирование репозитория
2. **Install OpenSCAD** - установка OpenSCAD и Xvfb (для headless режима)
3. **Build STL** - запуск `export_all_stl.sh`
4. **Determine path** - определение пути (current или версия)
5. **Upload artifacts** - загрузка в GitHub Artifacts
6. **Create Release** - (только для тегов) создание релиза
7. **Commit artifacts** - (только для main) коммит в artifacts/current

## Кастомизация

### Изменить retention период artifacts

В `.github/workflows/build-stl.yml`:
```yaml
retention-days: 90  # Измените на нужное значение (1-90)
```

### Отключить автокоммит в artifacts/

Удалите или закомментируйте шаг "Commit artifacts to repository".
Артефакты всё равно будут доступны как GitHub Artifacts.

### Добавить уведомления

Добавьте в конец workflow:
```yaml
- name: Notify on failure
  if: failure()
  uses: actions/github-script@v6
  with:
    script: |
      github.rest.issues.create({
        owner: context.repo.owner,
        repo: context.repo.repo,
        title: 'STL Build Failed',
        body: 'Automatic STL generation failed. Check the workflow logs.'
      })
```
