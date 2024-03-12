class PlayerView {
    var sceneView: MTKView
    var controlView: UIView

    init(rootView: UIView, drawDelegate: MTKViewDelegate) {
        self.sceneView = MTKView(frame: frame, device: self.device)
        self.sceneView.delegate = drawDelegate
        rootView.addSubview(self.sceneView)

        self.controlView = ControlView(frame: frame)
        rootView.addSubview(self.controlView)
    }

    func setupSubviews() {
        self.controlView.setupSubviews()
    }
}