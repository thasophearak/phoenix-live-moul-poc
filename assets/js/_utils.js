import fixed_partition from '../vendor/layout'

export const $ = (el) => document.querySelector(el)
export const $$ = (el) => document.querySelectorAll(el)

export const getDimension = (width, height, maxWidth, maxHeight) => {
	const ratio = Math.min(maxWidth / width, maxHeight / height)
	return { width: width * ratio, height: height * ratio }
}

export let painGrid = () => {
	const grid = document.querySelectorAll('.moul-content-photos')
	grid.forEach((g) => {
		const photos = g.querySelectorAll('.moul-grid')
		const photosSize = []
		photos.forEach((p) => {
			const [w, h] = p.getAttribute('data-size').split(':')
			const { width, height } = getDimension(+w, +h, 2048, 2048)
			photosSize.push({ width, height })
		})

		const idealElementHeight = document.body.clientWidth < 800 ? 280 : 380
		const containerWidth =
			document.body.clientWidth > 2000 && photosSize.length < 4
				? 1800
				: document.body.clientWidth > 3000
				? 2400
				: document.body.clientWidth
		const layout = fixed_partition(photosSize, {
			containerWidth,
			idealElementHeight,
			spacing: 16,
		})
		g.classList.add('is-grid')
		g.style.width = `${layout.width}px`
		g.style.height = `${layout.height}px`

		layout.positions.forEach((_, i) => {
			photos[i].style.position = `absolute`
			photos[i].style.top = `${layout.positions[i].y}px`
			photos[i].style.left = `${layout.positions[i].x}px`
			photos[i].style.width = `${layout.positions[i].width}px`
			photos[i].style.height = `${layout.positions[i].height}px`
		})
	})
}

export let painDarkbox = ({ loading, kind, to }) => {
	$('#js-current-width')?.setAttribute('style', `width: ${window.innerWidth}px`)
	$$('.js-min-width').forEach((el) =>
		el.setAttribute('style', `min-width: ${window.innerWidth}px`)
	)
	const wrapper = $$('.moul-darkbox-list').length * window.innerWidth
	const wrapperEl = $('#js-wrapper')

	if (wrapperEl) {
		wrapperEl.style.width = `${wrapper}px`
		let activeIndex
		const currentPathname = location.pathname.split('/').pop()
		if (loading == 'start' && kind == 'patch') {
			const photos = JSON.parse(
				document.querySelector('#js-photos').getAttribute('value')
			)
			toIndex = photos.findIndex((p) => p.hash == to)
			currentIndex = photos.findIndex((p) => p.hash == currentPathname)
			activeIndex = toIndex > currentIndex ? currentIndex + 1 : currentIndex - 1
		} else {
			activeIndex = document
				.querySelector('#js-active-index')
				.getAttribute('value')
		}

		wrapperEl.style.transform = `translateX(-${
			window.innerWidth * +activeIndex
		}px)`

		if (loading == 'stop' && kind == 'initial') {
			localStorage.setItem('hide-moul-control', 'false')
		}

		const hideMoul = localStorage.getItem('hide-moul-control')
		hideMoul == 'true' && $('#js-moul-control').classList.add('hidden')

		const photos = document.querySelectorAll('.moul-darkbox-list picture')
		photos.forEach((p) => {
			let [w, h] = p.getAttribute('data-size').split(':')
			let { width, height } = getDimension(
				w,
				h,
				window.innerWidth,
				window.innerHeight
			)
			p.querySelector('img').style.width = `${width}px`
			p.querySelector('img').style.height = `${height}px`
			p.addEventListener('click', () => {
				$('#js-moul-control').classList.toggle('hidden')
				localStorage.setItem(
					'hide-moul-control',
					$('#js-moul-control').classList.contains('hidden')
				)
			})
		})
		if (+activeIndex == 0) {
			$('.js-prev-link').classList.add('hidden')
		}
		const total = $('#js-total-count').getAttribute('value')
		if (+activeIndex == total - 1) {
			$('.js-next-link').classList.add('hidden')
		}

		$('.moul-darkbox-photo').classList.remove('hidden')
	}
}
