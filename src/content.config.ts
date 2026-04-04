import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const str = z.string().nullish();
const num = z.number().nullish();
const tags = z.array(z.string()).nullish();

const concepts = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/concepts" }),
  schema: z.object({
    member: str,
    week: num,
    tags,
    keywords: z.array(z.string()).nullish(),
  }).passthrough(),
});

const insights = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/insights" }),
  schema: z.object({
    member: str,
    tags,
  }).passthrough(),
});

const gallery = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/gallery" }),
  schema: z.object({
    name: str,
    maker: str,
    thumbnail: str,
    link: str,
    week: num,
  }).passthrough(),
});

const tools = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/tools" }),
  schema: z.object({
    name: str,
    category: str,
    type: str,
    difficulty: str,
    link: str,
    added_by: str,
  }).passthrough(),
});

const analysis = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/analysis" }),
  schema: z.object({
    week: num,
    date: z.coerce.string().nullish(),
    tags,
    total_submissions: num,
  }).passthrough(),
});

const proposals = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/proposals" }),
  schema: z.object({
    tags,
  }).passthrough(),
});

export const collections = { concepts, insights, gallery, tools, analysis, proposals };
