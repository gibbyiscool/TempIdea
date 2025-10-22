# LVGL Cloud Editor Integration

## Workflow

1. **Design** in LVGL Cloud Editor
2. **Export** generated code
3. **Sync** to firmware
4. **Build** and test

## Exporting from Cloud Editor

1. Click "Export" in editor
2. Download ZIP containing:
   - `examples_gen.c/h` (generated UI)
   - `examples.c/h` (custom code)
   - Asset files

3. Extract to `lvgl-project/`

## Syncing to Firmware

```bash
./scripts/sync_lvgl.sh
```

This copies generated code to `firmware/src/ui/generated/`

## Custom Event Handlers

Add custom logic in `firmware/src/ui/custom/`:

```c
void ui_event_button_clicked(lv_event_t *e) {
    // Your custom logic
    temp_controller_set_target_temp(25.0f);
}
```

## Best Practices

- Keep XML sources in version control
- Commit generated code for reproducibility
- Use custom event handlers for hardware interaction
- Test UI in simulator before flashing
