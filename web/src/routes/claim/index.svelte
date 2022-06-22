<script context="module">
	import { browser, dev } from '$app/env';
	import { ButtonGroup, ButtonGroupItem ,Button, Icon, Container, Row, Select, Col, TextField } from 'svelte-materialify';
	import SegmentedButton, { Segment } from '@smui/segmented-button';
	import { Label } from '@smui/common';
	import { mdiCurrencyUsd } from '@mdi/js';
	// we don't need any JS on this page, though we'll load
	// it in dev so that we get hot module replacement...
	export const hydrate = dev;

	// ...but if the client-side router is already loaded
	// (i.e. we came here from elsewhere in the app), use it
	export const router = browser;

	// since there's no dynamic data here, we can prerender
	// it so that it gets served as a static asset in prod
	export const prerender = true;

	const items = ['foo', 'bar', 'fizz', 'buzz'];
	let value = 1;

</script>

<svelte:head>
	<title>Claim</title>
	<meta name="description" content="Claim a payment" />
</svelte:head>



<Container>
	<div class="content">
		<Row>
			<Col>
                  <Select outlined {items}>Fund</Select>
			</Col>
		</Row>
	
	<Row class="align-center">
	  <Col>

			<TextField >
				<div slot="prepend-outer">
					<Icon path={mdiCurrencyUsd} />
				  </div>
				  Amount
			</TextField>
		  
	  </Col>
	  <Col>
		<div class=" d-flex justify-center">
			<Button depressed>Pay Me</Button>
		</div>
	  </Col>
	</Row>
	<Row class="d-flex justify-center">
		<ButtonGroup activeClass="primary-color" bind:value>
			<ButtonGroupItem>Fund</ButtonGroupItem>
			<ButtonGroupItem>User</ButtonGroupItem>
		  </ButtonGroup>
	</Row>
  </div> 
  </Container>


  


<style>
	.content {
		width: 100%;
		max-width: var(--column-width);
		margin: var(--column-margin-top) auto 0 auto;
		justify-content: center;
	}

</style>
