import QtQuick

Item {
    id: root

    property real menuX: 455
    property real selectionY: 180

    property color accent: "#61b8ff"
    property string visualKey: "multimedia"

    property bool motionEnabled: true
    property bool particlesEnabled: true

    property real phase: 0
    property color pendingAccent: accent
    property string pendingVisualKey: visualKey

    property real medallionCenterY: height * 0.52

    Behavior on selectionY {
        NumberAnimation {
            duration: 170
            easing.type: Easing.OutCubic
        }
    }

    NumberAnimation on phase {
        from: 0
        to: Math.PI * 2
        duration: 16000
        loops: Animation.Infinite
        running: root.motionEnabled
    }

    function setImmediate(accentColor, key) {
        accent = accentColor
        visualKey = key
        backgroundCanvas.requestPaint()
        dividerCanvas.requestPaint()
        objectCanvas.requestPaint()
        connectorCanvas.requestPaint()
        iconCanvas.requestPaint()
    }

    function transitionTo(accentColor, key) {
        pendingAccent = accentColor
        pendingVisualKey = key
        swapAnimation.restart()
    }

    onPhaseChanged: {
        backgroundCanvas.requestPaint()
        objectCanvas.requestPaint()
        dividerCanvas.requestPaint()
        connectorCanvas.requestPaint()
    }

    onAccentChanged: {
        backgroundCanvas.requestPaint()
        dividerCanvas.requestPaint()
        objectCanvas.requestPaint()
        connectorCanvas.requestPaint()
        iconCanvas.requestPaint()
    }

    onVisualKeyChanged: {
        backgroundCanvas.requestPaint()
        objectCanvas.requestPaint()
        iconCanvas.requestPaint()
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#04070b" }
            GradientStop { position: 0.45; color: "#05080d" }
            GradientStop { position: 1.0; color: "#070b10" }
        }
    }

    Canvas {
        id: backgroundCanvas

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: root.menuX + 24
        opacity: 0.92

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            var w = width
            var h = height
            var t = root.phase

            ctx.clearRect(0, 0, w, h)

            var g = ctx.createLinearGradient(0, 0, w, 0)
            g.addColorStop(0.0, "#06090d")
            g.addColorStop(0.55, "#09111a")
            g.addColorStop(0.88, "#0d1621")
            g.addColorStop(1.0, "#111b27")
            ctx.fillStyle = g
            ctx.fillRect(0, 0, w, h)

            var mode = 0
            if (root.visualKey === "radio")
                mode = 1
            else if (root.visualKey === "navigation")
                mode = 2
            else if (root.visualKey === "performance")
                mode = 3
            else if (root.visualKey === "vehicle")
                mode = 4
            else
                mode = 0

            ctx.lineWidth = 1
            ctx.strokeStyle = root.accent

            if (mode === 0) {
                ctx.globalAlpha = 0.14
                for (var i = 0; i < 28; ++i) {
                    ctx.beginPath()
                    for (var x = -10; x < w; x += 7) {
                        var spread = (i - 13.5)
                        var baseY = h * 0.67 + spread * 7.0
                        var ripple =
                                Math.sin(x * 0.021 + t + i * 0.22) * 2.2 +
                                Math.sin(x * 0.008 - t * 0.55) * 1.2
                        var bend = (x / w) * spread * -5.0
                        var y = baseY + ripple + bend

                        if (x <= 0)
                            ctx.moveTo(x, y)
                        else
                            ctx.lineTo(x, y)
                    }
                    ctx.stroke()
                }
            } else if (mode === 1) {
                ctx.globalAlpha = 0.14
                var cx = 38
                var cy = h * 0.62
                for (var r = 50; r < 390; r += 13) {
                    ctx.beginPath()
                    ctx.arc(cx, cy, r + Math.sin(t + r * 0.03) * 1.5, -1.33, 0.65, false)
                    ctx.stroke()
                }
            } else if (mode === 2) {
                ctx.globalAlpha = 0.14
                var ox = 60
                var oy = h - 42
                for (var j = 0; j < 29; ++j) {
                    var targetY = 40 + j * 12 + Math.sin(t + j * 0.3) * 2.0
                    ctx.beginPath()
                    ctx.moveTo(ox, oy)
                    ctx.lineTo(w - 30, targetY)
                    ctx.stroke()
                }
            } else if (mode === 3) {
                ctx.globalAlpha = 0.13
                for (var a = 0; a < 25; ++a) {
                    ctx.beginPath()
                    for (var xx = 0; xx < w; xx += 8) {
                        var yy = 80 + a * 12 + Math.sin(xx * 0.017 + t + a * 0.24) * 4
                        if (xx === 0)
                            ctx.moveTo(xx, yy)
                        else
                            ctx.lineTo(xx, yy)
                    }
                    ctx.stroke()
                }
            } else if (mode === 4) {
                ctx.globalAlpha = 0.13
                for (var q = 0; q < 24; ++q) {
                    ctx.beginPath()
                    for (var x2 = 20; x2 < w - 20; x2 += 8) {
                        var yy2 =
                                h * 0.25 +
                                q * 11 +
                                Math.sin(x2 * 0.016 + t * 0.9 + q * 0.25) * 2.4
                        if (x2 === 20)
                            ctx.moveTo(x2, yy2)
                        else
                            ctx.lineTo(x2, yy2)
                    }
                    ctx.stroke()
                }
            }

            ctx.globalAlpha = 0.08
            ctx.lineWidth = 2
            for (var k = 0; k < 6; ++k) {
                ctx.beginPath()
                ctx.moveTo(root.menuX - 120 + k * 12, 18)
                ctx.bezierCurveTo(
                    root.menuX - 85 + k * 8, 140,
                    root.menuX - 88 + k * 8, h - 130,
                    root.menuX - 118 + k * 12, h - 20
                )
                ctx.stroke()
            }

            ctx.globalAlpha = 1.0
        }
    }

    Canvas {
        id: dividerCanvas

        x: root.menuX - 128
        y: 0
        width: 150
        height: parent.height
        opacity: 0.95

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            var w = width
            var h = height

            ctx.clearRect(0, 0, w, h)

            var fill = ctx.createLinearGradient(0, 0, w, 0)
            fill.addColorStop(0.0, "rgba(18,30,43,0.00)")
            fill.addColorStop(0.45, "rgba(28,48,70,0.18)")
            fill.addColorStop(0.78, "rgba(40,66,94,0.36)")
            fill.addColorStop(1.0, "rgba(18,28,40,0.10)")
            ctx.fillStyle = fill

            ctx.beginPath()
            ctx.moveTo(22, 16)
            ctx.bezierCurveTo(80, 120, 90, h - 130, 32, h - 18)
            ctx.lineTo(w, h - 18)
            ctx.lineTo(w, 16)
            ctx.closePath()
            ctx.fill()

            ctx.lineWidth = 2.2
            ctx.strokeStyle = "rgba(205,232,255,0.32)"
            ctx.beginPath()
            ctx.moveTo(28, 16)
            ctx.bezierCurveTo(86, 118, 95, h - 128, 38, h - 18)
            ctx.stroke()

            ctx.lineWidth = 1.3
            ctx.strokeStyle = "rgba(120,210,255,0.44)"
            ctx.beginPath()
            ctx.moveTo(42, 30)
            ctx.bezierCurveTo(88, 126, 95, h - 142, 49, h - 30)
            ctx.stroke()

            ctx.lineWidth = 0.9
            ctx.strokeStyle = "rgba(145,225,255,0.22)"
            for (var i = 0; i < 4; ++i) {
                ctx.beginPath()
                ctx.moveTo(16 + i * 9, 34 + i * 4)
                ctx.bezierCurveTo(60 + i * 10, 120, 70 + i * 10, h - 135, 24 + i * 9, h - 34 - i * 4)
                ctx.stroke()
            }
        }
    }

    Canvas {
        id: objectCanvas

        x: 18
        y: 40
        width: root.menuX - 150
        height: parent.height - 80
        opacity: 0.92

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            var w = width
            var h = height
            var t = root.phase

            ctx.clearRect(0, 0, w, h)

            var cx = w * 0.48
            var cy = h * 0.53
            var s = Math.min(w, h) * 0.30

            function strokeCircle(x, y, r, a, lw) {
                ctx.globalAlpha = a
                ctx.lineWidth = lw
                ctx.beginPath()
                ctx.arc(x, y, r, 0, Math.PI * 2, false)
                ctx.stroke()
            }

            function drawMultimedia() {
                ctx.strokeStyle = root.accent
                strokeCircle(cx, cy, s * 0.70, 0.26, 1.4)
                strokeCircle(cx, cy, s * 0.95, 0.12, 1.0)
                strokeCircle(cx, cy, s * 1.15, 0.08, 1.0)

                ctx.globalAlpha = 0.72
                ctx.lineWidth = 2.1

                ctx.beginPath()
                ctx.arc(cx, cy, s * 0.48, 0, Math.PI * 2, false)
                ctx.stroke()

                ctx.beginPath()
                ctx.moveTo(cx + s * 0.10, cy - s * 0.30)
                ctx.lineTo(cx + s * 0.10, cy + s * 0.18)
                ctx.lineTo(cx + s * 0.40, cy + s * 0.10)
                ctx.lineTo(cx + s * 0.40, cy - s * 0.38)
                ctx.stroke()

                ctx.beginPath()
                ctx.arc(cx - s * 0.02, cy + s * 0.26, s * 0.14, 0, Math.PI * 2, false)
                ctx.stroke()

                ctx.beginPath()
                ctx.arc(cx + s * 0.34, cy + s * 0.18, s * 0.14, 0, Math.PI * 2, false)
                ctx.stroke()
            }

            function drawRadio() {
                ctx.strokeStyle = root.accent
                ctx.globalAlpha = 0.72
                ctx.lineWidth = 2.0

                ctx.beginPath()
                ctx.moveTo(cx, cy + s * 0.55)
                ctx.lineTo(cx, cy - s * 0.08)
                ctx.stroke()

                ctx.beginPath()
                ctx.moveTo(cx - s * 0.11, cy + s * 0.55)
                ctx.lineTo(cx + s * 0.11, cy + s * 0.55)
                ctx.stroke()

                for (var i = 0; i < 3; ++i) {
                    var rr = s * (0.33 + i * 0.22) + Math.sin(t + i) * 1.5
                    ctx.globalAlpha = 0.22 - i * 0.04
                    ctx.beginPath()
                    ctx.arc(cx, cy - s * 0.10, rr, -0.95, -0.18, false)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.arc(cx, cy - s * 0.10, rr, -2.96, -2.18, false)
                    ctx.stroke()
                }

                ctx.globalAlpha = 0.72
                ctx.beginPath()
                ctx.arc(cx, cy - s * 0.10, s * 0.06, 0, Math.PI * 2, false)
                ctx.stroke()
            }

            function drawTelephone() {
                ctx.strokeStyle = root.accent
                ctx.globalAlpha = 0.74
                ctx.lineWidth = 2.2

                ctx.beginPath()
                ctx.moveTo(cx - s * 0.26, cy - s * 0.10)
                ctx.bezierCurveTo(cx - s * 0.10, cy - s * 0.32, cx + s * 0.10, cy - s * 0.32, cx + s * 0.26, cy - s * 0.10)
                ctx.stroke()

                ctx.beginPath()
                ctx.moveTo(cx - s * 0.26, cy + s * 0.10)
                ctx.bezierCurveTo(cx - s * 0.10, cy + s * 0.32, cx + s * 0.10, cy + s * 0.32, cx + s * 0.26, cy + s * 0.10)
                ctx.stroke()

                ctx.beginPath()
                ctx.moveTo(cx - s * 0.33, cy - s * 0.03)
                ctx.bezierCurveTo(cx - s * 0.21, cy + s * 0.24, cx + s * 0.21, cy + s * 0.24, cx + s * 0.33, cy - s * 0.03)
                ctx.stroke()

                strokeCircle(cx, cy, s * 0.82, 0.10, 1.0)
            }

            function drawContacts() {
                ctx.strokeStyle = root.accent
                ctx.globalAlpha = 0.72
                ctx.lineWidth = 2.0

                ctx.beginPath()
                ctx.arc(cx - s * 0.12, cy - s * 0.16, s * 0.18, 0, Math.PI * 2, false)
                ctx.stroke()

                ctx.beginPath()
                ctx.moveTo(cx - s * 0.34, cy + s * 0.22)
                ctx.bezierCurveTo(cx - s * 0.30, cy + s * 0.02, cx + s * 0.05, cy + s * 0.02, cx + s * 0.10, cy + s * 0.22)
                ctx.stroke()

                ctx.lineWidth = 1.7
                for (var i = 0; i < 4; ++i) {
                    ctx.beginPath()
                    ctx.moveTo(cx + s * 0.18, cy - s * 0.22 + i * s * 0.16)
                    ctx.lineTo(cx + s * 0.54, cy - s * 0.22 + i * s * 0.16)
                    ctx.stroke()
                }

                ctx.globalAlpha = 0.20
                ctx.lineWidth = 1.0
                ctx.strokeRect(cx - s * 0.48, cy - s * 0.42, s * 1.15, s * 0.94)
            }

            function drawNavigation() {
                ctx.strokeStyle = root.accent
                strokeCircle(cx, cy, s * 0.82, 0.18, 1.2)

                ctx.globalAlpha = 0.78
                ctx.lineWidth = 2.2
                ctx.beginPath()
                ctx.moveTo(cx - s * 0.08, cy + s * 0.26)
                ctx.lineTo(cx + s * 0.22, cy - s * 0.20)
                ctx.lineTo(cx - s * 0.24, cy - s * 0.03)
                ctx.lineTo(cx - s * 0.03, cy + s * 0.02)
                ctx.closePath()
                ctx.stroke()

                ctx.globalAlpha = 0.28
                ctx.beginPath()
                ctx.arc(cx, cy, s * 0.53, -0.4 + Math.sin(t) * 0.03, 2.6 + Math.sin(t) * 0.03, false)
                ctx.stroke()
            }

            function drawVehicle() {
                ctx.strokeStyle = root.accent
                ctx.globalAlpha = 0.74
                ctx.lineWidth = 2.0

                ctx.beginPath()
                ctx.moveTo(cx - s * 0.52, cy + s * 0.18)
                ctx.lineTo(cx - s * 0.36, cy - s * 0.06)
                ctx.lineTo(cx - s * 0.10, cy - s * 0.20)
                ctx.lineTo(cx + s * 0.26, cy - s * 0.20)
                ctx.lineTo(cx + s * 0.46, cy - s * 0.02)
                ctx.lineTo(cx + s * 0.56, cy + s * 0.18)
                ctx.stroke()

                ctx.beginPath()
                ctx.moveTo(cx - s * 0.52, cy + s * 0.18)
                ctx.lineTo(cx + s * 0.56, cy + s * 0.18)
                ctx.stroke()

                ctx.beginPath()
                ctx.arc(cx - s * 0.25, cy + s * 0.18, s * 0.13, 0, Math.PI * 2, false)
                ctx.stroke()

                ctx.beginPath()
                ctx.arc(cx + s * 0.30, cy + s * 0.18, s * 0.13, 0, Math.PI * 2, false)
                ctx.stroke()

                ctx.globalAlpha = 0.18
                ctx.beginPath()
                ctx.moveTo(cx - s * 0.06, cy - s * 0.18)
                ctx.lineTo(cx - s * 0.06, cy + s * 0.16)
                ctx.stroke()
            }

            function drawPerformance() {
                ctx.strokeStyle = root.accent
                ctx.globalAlpha = 0.75
                ctx.lineWidth = 2.0

                ctx.beginPath()
                ctx.arc(cx, cy, s * 0.72, Math.PI * 0.85, Math.PI * 0.15, true)
                ctx.stroke()

                for (var i = 0; i < 8; ++i) {
                    var ang = Math.PI * (0.85 - i * 0.10)
                    var r1 = s * 0.56
                    var r2 = s * 0.72
                    ctx.beginPath()
                    ctx.moveTo(cx + Math.cos(ang) * r1, cy + Math.sin(ang) * r1)
                    ctx.lineTo(cx + Math.cos(ang) * r2, cy + Math.sin(ang) * r2)
                    ctx.stroke()
                }

                var needle = -0.65 + Math.sin(t * 0.6) * 0.08
                ctx.beginPath()
                ctx.moveTo(cx, cy)
                ctx.lineTo(cx + Math.cos(needle) * s * 0.50, cy + Math.sin(needle) * s * 0.50)
                ctx.stroke()

                ctx.beginPath()
                ctx.arc(cx, cy, s * 0.08, 0, Math.PI * 2, false)
                ctx.stroke()
            }

            function drawDiagnostics() {
                ctx.strokeStyle = root.accent
                ctx.globalAlpha = 0.72
                ctx.lineWidth = 1.9

                var pts = [
                    [cx - s * 0.40, cy - s * 0.14],
                    [cx - s * 0.08, cy - s * 0.34],
                    [cx + s * 0.25, cy - s * 0.12],
                    [cx + s * 0.34, cy + s * 0.23],
                    [cx - s * 0.02, cy + s * 0.34],
                    [cx - s * 0.33, cy + s * 0.14]
                ]

                for (var i = 0; i < pts.length; ++i) {
                    for (var j = i + 1; j < pts.length; ++j) {
                        if ((i + j) % 2 === 0) {
                            ctx.globalAlpha = 0.20
                            ctx.beginPath()
                            ctx.moveTo(pts[i][0], pts[i][1])
                            ctx.lineTo(pts[j][0], pts[j][1])
                            ctx.stroke()
                        }
                    }
                }

                ctx.globalAlpha = 0.78
                for (var k = 0; k < pts.length; ++k) {
                    ctx.beginPath()
                    ctx.arc(pts[k][0], pts[k][1], s * 0.055, 0, Math.PI * 2, false)
                    ctx.stroke()
                }
            }

            function drawSettings() {
                ctx.strokeStyle = root.accent
                ctx.globalAlpha = 0.76
                ctx.lineWidth = 2.0

                var r1 = s * 0.28
                var r2 = s * 0.52

                ctx.beginPath()
                for (var i = 0; i < 12; ++i) {
                    var a = (Math.PI * 2 / 12) * i
                    var rr = (i % 2 === 0) ? r2 : r2 * 0.78
                    var px = cx + Math.cos(a) * rr
                    var py = cy + Math.sin(a) * rr

                    if (i === 0)
                        ctx.moveTo(px, py)
                    else
                        ctx.lineTo(px, py)
                }
                ctx.closePath()
                ctx.stroke()

                ctx.beginPath()
                ctx.arc(cx, cy, r1, 0, Math.PI * 2, false)
                ctx.stroke()

                ctx.beginPath()
                ctx.arc(cx, cy, s * 0.15, 0, Math.PI * 2, false)
                ctx.stroke()
            }

            if (root.visualKey === "multimedia")
                drawMultimedia()
            else if (root.visualKey === "radio")
                drawRadio()
            else if (root.visualKey === "telephone")
                drawTelephone()
            else if (root.visualKey === "contacts")
                drawContacts()
            else if (root.visualKey === "navigation")
                drawNavigation()
            else if (root.visualKey === "vehicle")
                drawVehicle()
            else if (root.visualKey === "performance")
                drawPerformance()
            else if (root.visualKey === "diagnostics")
                drawDiagnostics()
            else if (root.visualKey === "settings")
                drawSettings()
        }
    }

    Repeater {
        model: 14

        Rectangle {
            width: index % 4 === 0 ? 2 : 1
            height: width
            radius: width / 2

            color: index % 3 === 0 ? "#d9f4ff" : root.accent

            opacity: root.particlesEnabled ? (0.035 + (index % 4) * 0.015) : 0

            x: 28
               + ((index * 71) % Math.max(70, root.menuX - 110))
               + Math.sin(root.phase * 0.55 + index * 0.7) * 7

            y: 42
               + ((index * 53) % Math.max(80, root.height - 90))
               + Math.cos(root.phase * 0.47 + index * 1.21) * 6
        }
    }

    Canvas {
        id: connectorCanvas

        x: medallion.x + medallion.width - 4
        y: 0
        width: root.menuX - x + 14
        height: parent.height

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var startX = 0
            var startY = root.medallionCenterY
            var jointX = 36
            var endX = width
            var endY = root.selectionY

            ctx.strokeStyle = root.accent
            ctx.lineWidth = 2
            ctx.globalAlpha = 0.86

            ctx.beginPath()
            ctx.moveTo(startX, startY)
            ctx.lineTo(jointX, startY)
            ctx.lineTo(jointX, endY)
            ctx.lineTo(endX, endY)
            ctx.stroke()

            ctx.globalAlpha = 0.85
            ctx.beginPath()
            ctx.arc(jointX, endY, 3, 0, Math.PI * 2, false)
            ctx.stroke()

            ctx.globalAlpha = 0.20
            ctx.lineWidth = 5
            ctx.beginPath()
            ctx.moveTo(jointX + 4, endY)
            ctx.lineTo(endX, endY)
            ctx.stroke()

            ctx.globalAlpha = 1.0
        }
    }

    Rectangle {
        id: medallion

        width: 96
        height: 96
        radius: width / 2

        x: root.menuX - 150
        y: root.medallionCenterY - height / 2

        color: "#0d141b"
        border.width: 2
        border.color: root.accent

        Rectangle {
            anchors.centerIn: parent
            width: parent.width - 14
            height: width
            radius: width / 2
            color: "#070c12"
            border.width: 1
            border.color: "#7f8da0"
        }

        Rectangle {
            anchors.centerIn: parent
            width: parent.width + 10
            height: width
            radius: width / 2
            color: "transparent"
            border.width: 1
            border.color: root.accent
            opacity: 0.22
        }

        Canvas {
            id: iconCanvas
            anchors.centerIn: parent
            width: 56
            height: 56

            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width
                var h = height
                var cx = w / 2
                var cy = h / 2
                var s = Math.min(w, h) * 0.42

                ctx.clearRect(0, 0, w, h)
                ctx.strokeStyle = "#f2f8ff"
                ctx.lineWidth = 2
                ctx.globalAlpha = 0.92

                if (root.visualKey === "multimedia") {
                    ctx.beginPath()
                    ctx.moveTo(cx + s * 0.05, cy - s * 0.70)
                    ctx.lineTo(cx + s * 0.05, cy + s * 0.20)
                    ctx.lineTo(cx + s * 0.62, cy + s * 0.02)
                    ctx.lineTo(cx + s * 0.62, cy - s * 0.76)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.arc(cx - s * 0.10, cy + s * 0.48, s * 0.24, 0, Math.PI * 2, false)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.arc(cx + s * 0.55, cy + s * 0.28, s * 0.24, 0, Math.PI * 2, false)
                    ctx.stroke()
                } else if (root.visualKey === "radio") {
                    ctx.beginPath()
                    ctx.moveTo(cx, cy + s * 0.70)
                    ctx.lineTo(cx, cy - s * 0.08)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.moveTo(cx - s * 0.20, cy + s * 0.70)
                    ctx.lineTo(cx + s * 0.20, cy + s * 0.70)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.arc(cx, cy - s * 0.05, s * 0.55, -0.95, -0.15, false)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.arc(cx, cy - s * 0.05, s * 0.55, -2.99, -2.20, false)
                    ctx.stroke()
                } else if (root.visualKey === "telephone") {
                    ctx.beginPath()
                    ctx.moveTo(cx - s * 0.72, cy - s * 0.05)
                    ctx.bezierCurveTo(cx - s * 0.30, cy - s * 0.55, cx + s * 0.30, cy - s * 0.55, cx + s * 0.72, cy - s * 0.05)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.moveTo(cx - s * 0.72, cy + s * 0.05)
                    ctx.bezierCurveTo(cx - s * 0.30, cy + s * 0.55, cx + s * 0.30, cy + s * 0.55, cx + s * 0.72, cy + s * 0.05)
                    ctx.stroke()
                } else if (root.visualKey === "contacts") {
                    ctx.beginPath()
                    ctx.arc(cx - s * 0.18, cy - s * 0.18, s * 0.30, 0, Math.PI * 2, false)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.moveTo(cx - s * 0.58, cy + s * 0.44)
                    ctx.bezierCurveTo(cx - s * 0.48, cy + s * 0.10, cx + s * 0.08, cy + s * 0.10, cx + s * 0.16, cy + s * 0.44)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.moveTo(cx + s * 0.35, cy - s * 0.28)
                    ctx.lineTo(cx + s * 0.78, cy - s * 0.28)
                    ctx.moveTo(cx + s * 0.35, cy)
                    ctx.lineTo(cx + s * 0.78, cy)
                    ctx.moveTo(cx + s * 0.35, cy + s * 0.28)
                    ctx.lineTo(cx + s * 0.78, cy + s * 0.28)
                    ctx.stroke()
                } else if (root.visualKey === "navigation") {
                    ctx.beginPath()
                    ctx.arc(cx, cy, s * 0.88, 0, Math.PI * 2, false)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.moveTo(cx - s * 0.12, cy + s * 0.38)
                    ctx.lineTo(cx + s * 0.42, cy - s * 0.32)
                    ctx.lineTo(cx - s * 0.40, cy - s * 0.06)
                    ctx.lineTo(cx - s * 0.06, cy + s * 0.06)
                    ctx.closePath()
                    ctx.stroke()
                } else if (root.visualKey === "vehicle") {
                    ctx.beginPath()
                    ctx.moveTo(cx - s * 0.90, cy + s * 0.25)
                    ctx.lineTo(cx - s * 0.58, cy - s * 0.10)
                    ctx.lineTo(cx - s * 0.18, cy - s * 0.24)
                    ctx.lineTo(cx + s * 0.42, cy - s * 0.24)
                    ctx.lineTo(cx + s * 0.78, cy + s * 0.00)
                    ctx.lineTo(cx + s * 0.90, cy + s * 0.25)
                    ctx.lineTo(cx - s * 0.90, cy + s * 0.25)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.arc(cx - s * 0.42, cy + s * 0.25, s * 0.20, 0, Math.PI * 2, false)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.arc(cx + s * 0.45, cy + s * 0.25, s * 0.20, 0, Math.PI * 2, false)
                    ctx.stroke()
                } else if (root.visualKey === "performance") {
                    ctx.beginPath()
                    ctx.arc(cx, cy, s * 0.84, Math.PI * 0.85, Math.PI * 0.15, true)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.lineTo(cx + s * 0.48, cy - s * 0.35)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.arc(cx, cy, s * 0.12, 0, Math.PI * 2, false)
                    ctx.stroke()
                } else if (root.visualKey === "diagnostics") {
                    var pts = [
                        [cx - s * 0.78, cy - s * 0.16],
                        [cx - s * 0.18, cy - s * 0.62],
                        [cx + s * 0.52, cy - s * 0.14],
                        [cx + s * 0.62, cy + s * 0.52],
                        [cx - s * 0.10, cy + s * 0.70],
                        [cx - s * 0.68, cy + s * 0.25]
                    ]

                    for (var i = 0; i < pts.length; ++i) {
                        ctx.beginPath()
                        ctx.arc(pts[i][0], pts[i][1], s * 0.10, 0, Math.PI * 2, false)
                        ctx.stroke()
                    }

                    ctx.beginPath()
                    ctx.moveTo(pts[0][0], pts[0][1])
                    ctx.lineTo(pts[1][0], pts[1][1])
                    ctx.lineTo(pts[2][0], pts[2][1])
                    ctx.lineTo(pts[3][0], pts[3][1])
                    ctx.lineTo(pts[4][0], pts[4][1])
                    ctx.lineTo(pts[5][0], pts[5][1])
                    ctx.lineTo(pts[0][0], pts[0][1])
                    ctx.stroke()
                } else if (root.visualKey === "settings") {
                    ctx.beginPath()
                    for (var t = 0; t < 12; ++t) {
                        var a = (Math.PI * 2 / 12) * t
                        var rr = (t % 2 === 0) ? s * 0.90 : s * 0.68
                        var px = cx + Math.cos(a) * rr
                        var py = cy + Math.sin(a) * rr
                        if (t === 0)
                            ctx.moveTo(px, py)
                        else
                            ctx.lineTo(px, py)
                    }
                    ctx.closePath()
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.arc(cx, cy, s * 0.34, 0, Math.PI * 2, false)
                    ctx.stroke()
                }
            }
        }
    }

    SequentialAnimation {
        id: swapAnimation

        ParallelAnimation {
            NumberAnimation {
                target: objectCanvas
                property: "opacity"
                to: 0.18
                duration: 95
            }

            NumberAnimation {
                target: medallion
                property: "scale"
                to: 0.88
                duration: 95
                easing.type: Easing.InQuad
            }

            NumberAnimation {
                target: medallion
                property: "opacity"
                to: 0.40
                duration: 95
            }
        }

        ScriptAction {
            script: {
                root.accent = root.pendingAccent
                root.visualKey = root.pendingVisualKey
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: objectCanvas
                property: "opacity"
                to: 0.92
                duration: 180
            }

            NumberAnimation {
                target: medallion
                property: "scale"
                to: 1.0
                duration: 170
                easing.type: Easing.OutBack
            }

            NumberAnimation {
                target: medallion
                property: "opacity"
                to: 1.0
                duration: 140
            }
        }
    }
}