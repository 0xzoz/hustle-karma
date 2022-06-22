<script>
	import { MaterialApp } from 'svelte-materialify';

	import { onMount } from 'svelte';
	import { Types, AptosClient } from 'aptos';
	import Header from '$lib/header/Header.svelte';
	import '../app.css';
	
	let address;
	


	async function connectWallet(){
		console.log(window.aptos.account())
		await  window.aptos.account().then((/** @type {any} */ res) => address = res);
	     console.log('address: ' + JSON.stringify(address))
	}
	onMount(connectWallet)

</script>

<Header />
<MaterialApp class="material-app">
<main>
	<slot />
</main>
</MaterialApp>
<footer>
	<p>Web 3 Social Capital</p>
</footer>

<style>


	main {
		flex: 1;
		display: flex;
		flex-direction: column;
		padding: 1rem;
		width: 100%;

		margin: 0 auto;
		height:90%;
		min-height:90vh;
		box-sizing: border-box;
		font-family: 'Noto Serif JP', serif;
			background-color: var(--primary-color);
	background: linear-gradient(
		180deg,
		var(--primary-color) 0%,
		var(--secondary-color) 10.45%,
		var(--tertiary-color) 41.35%
	);
	}

	body {
	min-height: 100vh;
	margin: 0;

	}



	footer {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		padding: 5px;
		position: fixed;
		bottom: 0;
		width:100%;
	}

	footer a {
		font-weight: bold;
		font-family:roboto;
	}

	@media (min-width: 480px) {
		footer {
			padding: 5px 0;
		}
	}
</style>
