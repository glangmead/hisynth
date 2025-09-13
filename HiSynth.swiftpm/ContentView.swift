import SwiftUI
import AVFoundation


/// Welcome to **HiSynth**.
///
/// It is recommended to play around with HiSynth on an iPad device.
struct ContentView: View {

    @StateObject var core = HiSynthCore()
    @StateObject var walkthrough = WalkthroughController()

    init() {
        Fonts.registerAllFonts()
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: [GridItem(.adaptive(minimum: 180))]) {
                                OscillatorPanel(controller: core.oscillatorController)
                                EnvelopePanel(controller: core.envelopeController)
                                FilterPanel(controller: core.filterController)
                                LFOPanel(controller: core.lfoController)
                                AFXPanel(controller: core.afxController)
                                PresetPanel(controller: core.presetController!)
                            }.padding(4.0)
                        }.onChange(of: walkthrough.scrollTarget) { oldTarget, target in
                            withAnimation {
                                proxy.scrollTo(target)
                            }
                        }
                    }
                    .frame(height: geometry.size.height / 2.0)
                    RackView(controller: core.rackController)
                    VStack {
                        KeyboardView(core: core, rackController: core.rackController)
                    }
                }
                .background(Theme.gradientMain())
                .onAppear {
                    core.start()
                }
            }
            WelcomeView(isPresented: $walkthrough.presentWelcome)
        }.ignoresSafeArea(.keyboard)
            .environmentObject(walkthrough)
    }
}
/// For preview with iPad Pro (11-inch) in landscape mode.
struct AppPreviewProvider: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
    }
}


