<script context="module" >
	export const prerender = true;
</script>

<script >
	import Counter from '$lib/Counter.svelte';
</script>

<svelte:head>
	<title>Home</title>
	<meta name="description" content="Svelte demo app" />
</svelte:head>

<section>
	<h1>
		<span class="text-1">
			<p>work</p> <p><b>CAN</b></p> be chosen and permissionless
		</span>
		<span class="text-2">
		<p>work</p> <p><b>SHOULD</b></p><p> be co-operative and honest</p>
	    </span>
	</h1>
	<hr class="rounded">


	<!-- <Counter /> -->
</section>

<style>
	section {
		display: flex;
		flex-direction: column;
		justify-content: center;
		flex: 1;
	}
	p {
		margin:0;
	}

	h1 {
		width: 100%;
	}

	.text-1 {
		display: block;
		position: relative;
		width: 100%;
		height: 0;
		text-align:left;
		padding-bottom:25%;
	}

	.text-2 {
		display: block;
		position: relative;
		width: 100%;
		height: 0;
		text-align:right;
		padding-bottom:40%;
	}

	.welcome img {
		position: absolute;
		width: 100%;
		height: 100%;
		top: 0;
		display: block;
	}

	hr.rounded {
		border-top: 3px solid rgb(6, 6, 6);
		border-radius: 5px;
		width:90%;
		position: relative;
	}
</style>
