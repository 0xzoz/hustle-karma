<script>
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
</script>


<div class="content">
	<h1>Rules</h1>

    <h2>Create</h2>

    <p>
        Anyone can create a Fund. A Fund is a template that can be used to place funds in for Workers to claim. A Worker determines the amount they should be paid and can request at any time. The creator of the fund is the first Police. 
	</p>

	<h2>Fund</h2>

	<p>
        Funds are used for specific purposes. An example would be Fund for a DAO's Engineering working group, the Fund holds an amount of funds that can added to, at any time, by anyone.
	</p>

    <h2>Get Paid</h2>

    <p>
       Give a description of the task, the amount you believe you deserve and click <i>Pay Me</i>. The payment will then go in the queue and once the wait time has elapsed or a Police has approved, you will be paid.   

	</p>


    <h2>Police</h2>


	<p>
        Police are what keep the system honest. The creator of the Fund is the first police. A police can add more police to the Fund. Police can stop a transaction if it is considered dishonest. 
	</p>
</div>

<style>
	.content {
		width: 100%;
		max-width: var(--column-width);
		margin: var(--column-margin-top) auto 0 auto;
		justify-content: center;
	}

	h1 {
			font-size: 2rem;
		}

	h2 {
		font-size: 1.2rem;
	}

	@media only screen and (max-width: 500px) {
		h1 {
			font-size: 2rem;
		}

		h2 {
			font-size: 1.2rem;
		}
   }

</style>
