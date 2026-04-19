import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const str = z.string().nullish();
const num = z.number().nullish();
const tags = z.array(z.string()).nullish();

const skills = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/skills" }),
  schema: z.object({
    title: str,
    author: str,
    summary: str,
    link: str,
    keywords: z.array(z.string()).nullish(),
    category: str,
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

const analysis = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/analysis" }),
  schema: z.object({
    week: num,
    date: z.coerce.string().nullish(),
    title: z.string().nullish(),
    description: z.string().nullish(),
    tags,
    total_submissions: num,
  }).passthrough(),
});

const proposals = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/proposals" }),
  schema: z.object({
    tags,
    count: num,
    preview: str,
    highlights: z.array(z.string()).nullish(),
    last_updated: z.coerce.string().nullish(),
  }).passthrough(),
});

const missions = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/missions" }),
  schema: z.object({}).passthrough(),
});

const members = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/members" }),
  schema: z.object({
    name: str,
    role: str,
    desc: str,
    linkedin: str,
    avatar: str,
  }).passthrough(),
});

export const collections = { skills, gallery, analysis, proposals, missions, members };
