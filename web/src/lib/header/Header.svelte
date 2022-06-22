<script>
	import { page } from '$app/stores';
	import logo from './karma-logo.jpg';
	import { Icon, Container, Row, Col } from 'svelte-materialify';
	import { mdiGithub } from '@mdi/js';
</script>

<header>


<Col >
	<div class="corner">
		
		<a class:active={$page.url.pathname === '/'} href="/" class="logo-text">
			<p class="logo">∞</p> Karma

		</a>
	</div>
</Col>
<Col >

	<nav>

		<ul>
			<li class:active={$page.url.pathname === '/claim'}>
				<a sveltekit:prefetch href="/claim">Claim</a>
			</li>
			<li class:active={$page.url.pathname === '/verify'}>
				<a sveltekit:prefetch href="/verify">Verify</a>
			</li>
			<li class:active={$page.url.pathname === '/rules'}>
				<a sveltekit:prefetch href="/rules">Rules</a>
			</li>
		</ul>

	</nav>
</Col>
<Col>

	<div  class="code-link">
		<a  class="github-icon" href="https://github.com/0xzoz/hustle-karma"><Icon size="32px" path={mdiGithub} /></a>>	
	</div>
</Col>

</header>

<style>
	header {
		font-family: 'Cinzel', serif;
	    display: flex;
		justify-content: space-between;
		background:rgb(52, 50, 50);
		width:100;
		height:60px;
	}


	a, u {
 	 text-decoration: none;
	}

	.logo {
		font-size:4rem ;
		line-height: 10%;
		margin: 0;
		color: rgb(188, 130, 243);
		text-shadow: -1px -1px 0 #fff, 1px -1px 0 #fff, -1px 1px 0 #fff, 1px 1px 0 #fff;

	}

	.logo-text {
		font-size: 2rem;
		color:white;
	}


	.corner a {
		display: flex;
		align-items: center;
		justify-content: left;
		width: 100%;
		height: 100%;
		padding-left:3%;

	}



	.corner img {
		width: 2em;
		height: 2em;
		object-fit: contain;
	}

	nav {
		display: flex;
		justify-content: center;
	}

	svg {
		width: 2em;
		height: 3em;
		display: block;
	}

	path {
		fill: var(--background);
	}

	ul {
		position: relative;
		padding: 0;
		margin: 0;
		height: 3em;
		display: flex;
		justify-content: right;
		align-items: right;
		list-style: none;
		background: var(--background);
		background-size: contain;
	}

	li {
		position: relative;
		height: 100%;
	}

	li.active::before {
		--size: 6px;
		content: '';
		width: 0;
		height: 0;
		position: absolute;
		top: 0;
		left: calc(50% - var(--size));
		border: var(--size) solid transparent;
		border-top: var(--size) solid var(--logo-color);
	}

	nav a {
		display: flex;
		height: 100%;
		align-items: center;
		padding: 0 1em;
		color: var(--accent-color);
		font-weight: 700;
		font-size: 0.8rem;
		text-transform: uppercase;
		letter-spacing: 0.1em;
		text-decoration: none;
		transition: color 0.2s linear;
	}

	a:hover {
		color: var(--logo-color);
	}

	.nav-grid {
		align-items: left;
	}
	.nav-logo {
		text-align: left;
	}

	.code-link {
		justify-content: right;
		text-align: right;
	}


	
</style>
