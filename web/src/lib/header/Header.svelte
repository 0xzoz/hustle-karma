<script>
	import { page } from '$app/stores';
	import logo from './karma-logo.jpg';
	import { Icon, Col } from 'svelte-materialify';
	import { mdiGithub } from '@mdi/js';
	import { onMount } from "svelte";

	// Show mobile icon and display menu
	let showMobileMenu = false;

	const handleMobileIconClick = () => (showMobileMenu = !showMobileMenu);

	const closeMobileIconClick = () => {if(showMobileMenu == true) {showMobileMenu =  !showMobileMenu}};

	// Media match query handler
	const mediaQueryHandler = e => {
	// Reset mobile state
	if (!e.matches) {
		showMobileMenu = false;
	}
	};
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
		<div class="inner">
		<div on:click={handleMobileIconClick} class={`mobile-icon${showMobileMenu ? ' active' : ''}`}>
			<div class="middle-line"></div>
		</div>

		<ul class={`navbar-list${showMobileMenu ? ' mobile' : ' not-mobile'}`}>
			<li class:active={$page.url.pathname === '/claim'}>
				<a on:click={closeMobileIconClick} sveltekit:prefetch href="/claim">Claim</a>
			</li>
			<li class:active={$page.url.pathname === '/verify'}>
				<a on:click={closeMobileIconClick}  sveltekit:prefetch href="/verify">Verify</a>
			</li>
			<li class:active={$page.url.pathname === '/rules'}>
				<a  on:click={closeMobileIconClick} sveltekit:prefetch href="/rules">Rules</a>
			</li>
			{#if showMobileMenu}
			<li >
				<a  class="github-icon" href="https://github.com/0xzoz/hustle-karma">Github</a>
			</li>
			{/if}
		</ul>

	</div>
	</nav>
</Col>
<Col>
		<div  class={`code-link${showMobileMenu ? ' mobile' : ''}`}>
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
		height: 45px;
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

	.code-link.mobile {
		display:none;
	}

	.inner {
		max-width: 980px;
		padding-left: 20px;
		padding-right: 20px;
		margin: auto;
		box-sizing: border-box;
		display: flex;
		align-items: center;
		height: 100%;
    }

	.mobile-icon {
		width: 25px;
		height: 14px;
		position: relative;
		cursor: pointer;
	}

	.mobile-icon:after,
	.mobile-icon:before,
	.middle-line {
		content: "";
		position: absolute;
		width: 100%;
		height: 2px;
		background-color: #fff;
		transition: all 0.4s;
		transform-origin: center;
	}

	.mobile-icon:before,
	.middle-line {
		top: 0;
	}

	.mobile-icon:after,
	.middle-line {
		bottom: 0;
	}

	.mobile-icon:before {
		width: 66%;
	}

	.mobile-icon:after {
		width: 33%;
	}

	.middle-line {
		margin: auto;
	}

	.mobile-icon:hover:before,
	.mobile-icon:hover:after,
	.mobile-icon.active:before,
	.mobile-icon.active:after,
	.mobile-icon.active .middle-line {
		width: 100%;
	}

	.mobile-icon.active:before,
	.mobile-icon.active:after {
		top: 50%;
		transform: rotate(-45deg);
	}

	.mobile-icon.active .middle-line {
		transform: rotate(45deg);
	}

	.navbar-list {
		display: none;
		width: 100%;
		justify-content: space-between;
		margin: 0;
		padding: 0 40px;
	}

	.navbar-list.mobile {
		z-index: 1;
		background-color: rgba(0, 0, 0, 0.8);
		position: fixed;
		display: block;
		height: calc(100vh - 45px);
		bottom: 0;
		left: 0;
	}

	.navbar-list li {
		list-style-type: none;
		position: relative;
	}

	.navbar-list  li:before {
		content: "";
		position: absolute;
		bottom: 0;
		left: 0;
		width: 100%;
		height: 3px;
		background-color: #424245;
	}

	.not-mobile li.active::before {
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


	.navbar-list.mobile li.active::before {
		--size: 6px;
		content: '';
		width: 0;
		height: 0;
		position: absolute;
		top: 0;
	}

	.navbar-list a {
		color: #fff;
		text-decoration: none;
		display: flex;
		height: 45px;
		align-items: center;
		padding: 0 10px;
		font-size: 13px;
	}

	@media only screen and (min-width: 767px) {
	.mobile-icon {
		display: none;
	}

	.navbar-list {
		display: flex;
		padding: 0;
	}

	.navbar-list a {
		display: inline-flex;
	}
	}

	
</style>
