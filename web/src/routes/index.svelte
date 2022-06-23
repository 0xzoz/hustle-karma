<script context="module" >
	export const prerender = true;
	import { Row, Col, MaterialApp } from 'svelte-materialify';
</script>


<svelte:head>
	<title>Home</title>
	<meta name="description" content="Svelte demo app" />
</svelte:head>

<section>
	<Row>
		<h1 class="text-1">
			<span >
				<p>work</p> <p><b>CAN</b></p><p> be chosen and permissionless</p>
			</span>
		</h1>
    </Row>	
	<Row>
		<h1 class="text-2">
			<span >
			<p>work</p> <p><b>SHOULD</b></p><p> be co-operative and honest</p>
			</span>
		</h1>
    </Row>
	<hr class="rounded">


	<!-- <Counter /> -->
</section>

<style>
	section {
		display: flex;
		flex-direction: column;
		justify-content: center;
		flex: 1;
		margin: 5%
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
		font-size: 4rem;

	}

	.text-2 {
		display: block;
		position: relative;
		width: 100%;
		height: 0;
		text-align:right;
		font-size: 4rem;

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
		width:100%;
		position: relative;
	}

	@media (max-width: 600px) {


	p {
		
	}

	.text-1 {
		font-size: 2rem;
	}

	.text-2 {
		font-size: 2rem;
	}
}
</style>
