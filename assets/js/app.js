// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import 'phoenix_html'
import 'instant.page'
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from 'phoenix'
import { LiveSocket } from 'phoenix_live_view'
import topbar from '../vendor/topbar'
import lazySizes from 'lazysizes'
import { painDarkbox, painGrid } from './_utils'

lazySizes.cfg.lazyClass = 'lazy'
let csrfToken = document
	.querySelector("meta[name='csrf-token']")
	.getAttribute('content')
let liveSocket = new LiveSocket('/live', Socket, {
	params: { _csrf_token: csrfToken },
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: '#2563eb' }, shadowColor: 'rgba(0, 0, 0, .3)' })
let topBarScheduled = undefined
let loading, kind, to

window.addEventListener('phx:page-loading-start', (info) => {
	if (!topBarScheduled) {
		topBarScheduled = setTimeout(() => topbar.show(), 120)
	}
	if (info.detail.kind == 'patch') {
		loading = 'start'
		kind = info.detail.kind
		to = info.detail.to.split('/').pop()
		painDarkbox({ loading, kind, to })
	}
})
window.addEventListener('phx:page-loading-stop', (info) => {
	clearTimeout(topBarScheduled)
	topBarScheduled = undefined
	topbar.hide()

	painGrid()
	loading = 'stop'
	kind = info.detail.kind
	to = ''
	painDarkbox({ loading, kind, to })
})

let gridResize
window.addEventListener('resize', () => {
	clearTimeout(gridResize)
	gridResize = setTimeout(painGrid, 100)
})
let darboxResize
window.addEventListener('resize', () => {
	clearTimeout(darboxResize)
	darboxResize = setTimeout(painDarkbox({ loading, kind, to }), 100)
})
// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// liveSocket.enableDebug()
// liveSocket.enableLatencySim(600)
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
window.addEventListener('keyup', (event) => {
	if (document.querySelector('.js-close-link')) {
		switch (event.key) {
			case 'ArrowRight':
				const nextLink = document.querySelector('.js-next-link')
				nextLink && !nextLink.classList.contains('hidden') && nextLink.click()
				break
			case 'ArrowLeft':
				const prevLink = document.querySelector('.js-prev-link')
				prevLink && !prevLink.classList.contains('hidden') && prevLink.click()
				break
			case 'Escape':
				const closeLink = document.querySelector('.js-close-link')
				closeLink.click()
				break
		}
	}
})
