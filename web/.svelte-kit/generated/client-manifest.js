export { matchers } from './client-matchers.js';

export const components = [
	() => import("../../src/routes/__layout.svelte"),
	() => import("../runtime/components/error.svelte"),
	() => import("../../src/routes/claim/index.svelte"),
	() => import("../../src/routes/index.svelte"),
	() => import("../../src/routes/rules.svelte"),
	() => import("../../src/routes/verify/index.svelte")
];

export const dictionary = {
	"": [[0, 3], [1]],
	"claim": [[0, 2], [1]],
	"rules": [[0, 4], [1]],
	"verify": [[0, 5], [1], 1]
};