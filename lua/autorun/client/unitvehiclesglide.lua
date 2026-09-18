list.Set( "GlideCategories", "unitvehiclesglide", {
    name = "Unit Vehicles",
    icon = "unitvehicles/icons/MILESTONE_OUTRUN_PURSUITS_WON.png"
} )

function UVDrawCursorText(panel, text, font, x, y, color, xAlign, yAlign, outline, outlineColor, left, right)
    surface.SetFont(font)

    local textWidth = surface.GetTextSize(text)
    local availableWidth = right - left
    local drawX = x

    if textWidth > availableWidth then
        if panel:IsHovered() then
            local cursorX = panel:CursorPos()
            local centeredX = cursorX - textWidth * 0.5

            if xAlign == TEXT_ALIGN_LEFT then
                drawX = math.Clamp(centeredX, left, right - textWidth)
            else
                drawX = math.Clamp(centeredX + textWidth * 0.5, left + textWidth * 0.5, right - textWidth * 0.5)
            end
        elseif xAlign == TEXT_ALIGN_LEFT then
            drawX = left
        else
            drawX = (left + right) * 0.5
        end
    end

    local screenX, screenY = panel:LocalToScreen(left, 0)
    local _, screenBottom = panel:LocalToScreen(right, panel:GetTall())
    render.SetScissorRect(screenX, screenY, screenX + availableWidth, screenBottom, true)
    draw.SimpleTextOutlined(text, font, drawX, y, color, xAlign, yAlign, outline, outlineColor)
    render.SetScissorRect(0, 0, 0, 0, false)
end