# Useful functions for filtering on emails.

local addresses = {
  local meMail = $['author'].email,

  // Matches messages cc'ed to an address.
  cc(address): {
    cc: address,
  },

  // Matches messages cc'ed to any of the addresses.
  ccAny(addresses): {
    or+: [{ cc: a } for a in addresses],
  },

  // Matches messages from an address.
  from(address): {
    from: address,
  },

  // Matches messages from any of the addresses.
  fromAny(addresses): {
    or+: [{ from: a } for a in addresses],
  },

  // Matches messages from or to any of the addresses.
  fromOrToAny(froms, tos): {
    or+: [
      { or: [{ from: a } for a in froms] },
      { or: [{ to: a } for a in tos] },
    ]
  },

  // Matches messages to an email list.
  list(list): {
    list: list,
  },

  // Matches messages to any of the email lists.
  listAny(lists): {
    or+: [{ list: x } for x in lists],
  },

  // Matches messages to an address.
  to(address): {
    to: address,
  },

  // Matches messages to any of the addresses.
  toAny(addresses): {
    or+: [{ to: a } for a in addresses],
  },

  // Matches messages to or cc'ed to the address.
  toOrCC(address): {
    or+: [{ to: address }, { cc: address }],
  },

  // Matches messages to or cc'ed to any of the addresses.
  toOrCCAny(addresses): {
    or+: std.flattenArrays([[{ to: a }, { cc: a }] for a in addresses])
  },

  // Matches messages to my address.
  toMe: {
    or+: [{to: meMail }, {cc: meMail }, {bcc: meMail }],
  },

  // Matches messages that do not to: my address.
  notToMe: {
    not: { to: meMail },
  },

  // Matches messages that do not to:, cc:, or bcc: my address.
  notIncludeMe: {
    not: { or: [{to: meMail }, {cc: meMail }, {bcc: meMail }]},
  },
};

local stdPatch = {
  // Until this is released in github.com/google/go-jsonnet & included in
  // gmailctl:
  flattenDeepArray(value):
    if std.isArray(value) then
      [y for x in value for y in self.flattenDeepArray(x)]
    else
      [value],
};

local operators = {
  _(f): {
    filter: f,
  },

  _and_not_to_me(f): {
    filter: { and: stdPatch.flattenDeepArray([[f], addresses.notToMe]) },
  },

  _and_not_include_me(f): {
    filter: { and: stdPatch.flattenDeepArray([[f], addresses.notIncludeMe]) },
  },

  and(filters): {
    and+: filters,
  },

  or(filters): {
    or+: filters,
  },

  not(f): {
    not: f,
  },
};

local querying = {
  // Matches messages with a given term.
  has(term): {
    has: term,
  },

  // Matches messages with any of the given terms.
  hasAny(terms): {
    or+: [{ has: t } for t in terms],
  },
};

local subjects = {
  // Matches messages with a given subject.
  subject(subject): {
    subject: subject,
  },

  // Matches messages from any of the subjects.
  subjectAny(subjects): {
    or+: [{ subject: s } for s in subjects],
  },
};

addresses + operators + querying + subjects
