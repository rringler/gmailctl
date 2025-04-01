# Useful actions for email filtering.

{
  // Archives messages (aka skip the inbox).
  archive: {
    actions+: { archive: true, },
  },

  // Archive and mark as read.
  rarchive: {
    actions+: { archive: true, markRead: true, }
  },

  // Marks as read.
  read: {
    actions+: { markRead: true, },
  },

  // Adds a star.
  star: {
    actions+: { star: true, },
  },

  // Marks as spam.
  spam: {
    actions+: { markSpam: true, },
  },

  // Marks as not spam.
  notspam: {
    actions+: { markSpam: false, },
  },

  // Marks as important.
  important: {
    actions+: { markImportant: true, },
  },

  // Marks as not important.
  unimportant: {
    actions+: { markImportant: false, },
  },

  // Apply a category
  _category(category): {
    actions+: { category: category, }
  },

  personal(): self._category('personal'),
  social(): self._category('social'),
  updates(): self._category('updates'),
  forums(): self._category('forums'),
  promotions(): self._category('promotions'),

  // Apply a label
  label(label): self.labels([label]),

  // Apply multiple labels
  labels(labels): {
    actions+: { labels: labels, },
  },

  // CUSTOM actions
  skip: self.archive + self.unimportant + self.notspam,
}
