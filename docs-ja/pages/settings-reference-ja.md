> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# すべての設定

> Claude Code の settings.json キーの完全なリファレンス：各キーの場所、型とデフォルト値、貼り付け可能な例、およびすべてのキーのインデックス。

export const BackToIndex = ({href = '#all-settings', label = 'Back to index'}) => {
  const [show, setShow] = useState(false);
  useEffect(() => {
    const onScroll = () => setShow(window.scrollY > window.innerHeight);
    onScroll();
    window.addEventListener('scroll', onScroll, {
      passive: true
    });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);
  return <div className="not-prose">
      <style>{`
        .bti-btn {
          position: fixed; right: 20px; bottom: 20px; z-index: 40;
          display: inline-flex; align-items: center; gap: 6px;
          padding: 8px 12px; border-radius: 999px;
          font-size: 13px; font-weight: 500; line-height: 1; text-decoration: none;
          color: #1f1f1f; background: #ffffff; border: 1px solid #d9d9d9;
          box-shadow: 0 2px 8px rgba(0,0,0,0.12);
          opacity: 0; pointer-events: none; transform: translateY(6px);
          transition: opacity 160ms ease, transform 160ms ease;
        }
        .bti-btn.bti-show { opacity: 1; pointer-events: auto; transform: translateY(0); }
        .bti-btn:hover { border-color: #b3b3b3; }
        .dark .bti-btn { color: #ececec; background: #1e1e1e; border-color: #3a3a3a; box-shadow: 0 2px 8px rgba(0,0,0,0.5); }
        .dark .bti-btn:hover { border-color: #5a5a5a; }
        @media (max-width: 1279px) { .bti-btn { bottom: 112px; } }
        @media print { .bti-btn { display: none; } }
      `}</style>
      <a className={'bti-btn' + (show ? ' bti-show' : '')} href={href} aria-hidden={!show} tabIndex={show ? 0 : -1}>
        <svg width="12" height="12" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true"><path d="M8 13V3M3.5 7.5 8 3l4.5 4.5" /></svg>
        {label}
      </a>
    </div>;
};

export const ReferenceFilter = ({placeholder, noun, facets, facetOrder, columnHelp, children}) => {
  const useLive = init => {
    const [v, setV] = useState(init);
    const ref = useRef(init);
    return [v, ref, x => {
      ref.current = x;
      setV(x);
    }];
  };
  const cap = s => s.charAt(0).toUpperCase() + s.slice(1);
  const plural = s => s.endsWith('y') ? s.slice(0, -1) + 'ies' : s + 's';
  const facetNames = facets || ['category', 'topic', 'scope', 'where'];
  const orderOf = {};
  Object.keys(facetOrder || ({})).forEach(k => {
    orderOf[k] = facetOrder[k].map(x => String(x).toLowerCase());
  });
  const rankIn = (col, v) => {
    const list = orderOf[col];
    if (!list) return -1;
    const i = list.indexOf(String(v).toLowerCase());
    return i < 0 ? list.length : i;
  };
  const cmpValues = col => (a, b) => {
    const ra = rankIn(col, a);
    const rb = rankIn(col, b);
    if (ra !== rb) return ra - rb;
    return a < b ? -1 : a > b ? 1 : 0;
  };
  const help = columnHelp || ({});
  const FIRST_COL_HELP = 'Click an entry to open it.';
  const optionLabel = (f, c) => c === 'All' ? 'All ' + plural(f.label.toLowerCase()) : c;
  const nounText = noun || 'entries';
  const placeholderText = placeholder || 'Filter this reference';
  const rootRef = useRef(null);
  const tablesRef = useRef(null);
  const searchRef = useRef(null);
  const menuRef = useRef({});
  const [q, qRef, setQ] = useLive('');
  const [sel, selRef, setSel] = useLive({});
  const [sortBy, sortRef, setSortBy] = useLive(null);
  const [menuOpen, menuOpenRef, setMenu] = useLive(null);
  const [facetList, setFacetList] = useState([]);
  const [firstHead, setFirstHead] = useState('');
  const [counts, setCounts] = useState({
    shown: 0,
    total: 0
  });
  const [disabled, setDisabled] = useState(false);
  const menuBtn = name => menuRef.current[name] ? menuRef.current[name].querySelector(':scope > button') : null;
  const menuList = name => menuRef.current[name] ? menuRef.current[name].querySelector('[role="listbox"]') : null;
  const closeMenu = name => {
    setMenu(null);
    const btn = menuBtn(name);
    if (btn) btn.focus();
  };
  const focusSelected = name => {
    const list = menuList(name);
    if (!list) return;
    const btn = list.querySelector('button[aria-selected="true"]') || list.querySelector('button');
    if (btn) btn.focus();
  };
  const setFacet = (name, value) => {
    setSel(Object.assign({}, selRef.current, {
      [name]: value
    }));
    apply(qRef.current);
    closeMenu(name);
  };
  const sortTables = by => {
    (tablesRef.current || []).forEach(tab => {
      const t = tab.el;
      const idx = tab.heads.indexOf(by);
      const body = t.querySelector('tbody');
      if (idx < 0 || !body) return;
      const rows = [...body.querySelectorAll('tr')];
      const keyOf = r => r.children[idx] ? r.children[idx].textContent.trim().toLowerCase() : '';
      const cmp = cmpValues(by);
      rows.map((r, i) => ({
        r,
        i: Number(r.dataset.sfIndex !== undefined ? r.dataset.sfIndex : i),
        k: keyOf(r)
      })).sort((a, b) => cmp(a.k, b.k) || a.i - b.i).forEach(x => body.appendChild(x.r));
      [...t.querySelectorAll('thead th')].forEach((h, i) => {
        const sortable = tab.heads[i] === tab.heads[0] || facetNames.indexOf(tab.heads[i]) > -1;
        if (sortable) h.setAttribute('aria-sort', i === idx ? 'ascending' : 'none'); else h.removeAttribute('aria-sort');
      });
    });
  };
  const scan = () => {
    const tables = [];
    let el = rootRef.current ? rootRef.current.nextElementSibling : null;
    while (el) {
      if (el.tagName === 'H2' || el.querySelector(':scope > h2')) break;
      const found = el.tagName === 'TABLE' ? [el] : [...el.querySelectorAll('table')];
      found.forEach(t => {
        const headCells = [...t.querySelectorAll('thead th, thead td')];
        const heads = headCells.map(h => h.textContent.trim().toLowerCase());
        if (heads.length === 0) return;
        const facetIdx = {};
        heads.forEach((h, i) => {
          if (facetNames.indexOf(h) > -1) facetIdx[h] = i;
        });
        if (!t.dataset.sfDecorated) {
          t.dataset.sfDecorated = '1';
          headCells.forEach((h, i) => {
            const text = i === 0 ? help[heads[0]] || FIRST_COL_HELP : help[heads[i]];
            if (text) h.title = text;
          });
        }
        const rows = [...t.querySelectorAll('tbody tr')].map((r, i) => {
          if (r.dataset.sfIndex === undefined) r.dataset.sfIndex = String(i);
          const cells = r.querySelectorAll('td');
          const fv = {};
          Object.keys(facetIdx).forEach(h => {
            fv[h] = cells[facetIdx[h]] ? cells[facetIdx[h]].textContent.trim() : '';
          });
          return {
            el: r,
            text: [...cells].map(c => c.textContent).join(' ').toLowerCase(),
            facets: fv,
            anchors: [...r.querySelectorAll('a[href^="#"]')].map(a => a.getAttribute('href').slice(1)),
            ids: [...r.querySelectorAll('[id]')].map(n => n.id)
          };
        });
        tables.push({
          el: t,
          box: t.closest('[data-table-wrapper]') || t,
          rows,
          heads
        });
      });
      el = el.nextElementSibling;
    }
    tablesRef.current = tables;
    if (sortRef.current) sortTables(sortRef.current);
    return tables;
  };
  const apply = query => {
    let tables = tablesRef.current || scan();
    if (tables.some(t => !t.el.isConnected)) tables = scan();
    const needle = query.trim().toLowerCase();
    const sel = selRef.current;
    const activeFacets = Object.keys(sel).filter(h => sel[h] && sel[h] !== 'All');
    const show = (el, on) => {
      const want = on ? '' : 'none';
      if (el.style.display !== want) el.style.display = want;
    };
    let total = 0;
    let shown = 0;
    const visibleTargets = new Set();
    tables.forEach(t => {
      let tableVisible = 0;
      t.rows.forEach(row => {
        total += 1;
        const catOk = activeFacets.every(h => {
          const v = row.facets[h];
          return v === sel[h] || v === '' || v === undefined;
        });
        const match = catOk && (needle === '' || row.text.includes(needle));
        show(row.el, match);
        if (match) {
          tableVisible += 1;
          row.anchors.forEach(a => visibleTargets.add(a));
        }
      });
      show(t.box, !(t.rows.length > 0 && tableVisible === 0));
      shown += tableVisible;
    });
    if (shown < total && visibleTargets.size > 0) {
      tables.forEach(t => {
        t.rows.forEach(row => {
          if (row.el.style.display === 'none' && row.ids.some(id => visibleTargets.has(id))) {
            show(row.el, true);
            show(t.box, true);
            shown += 1;
          }
        });
      });
    }
    setCounts({
      shown,
      total
    });
    return total;
  };
  const deriveFacets = tables => {
    const seen = {};
    tables.forEach(t => t.rows.forEach(r => {
      Object.keys(r.facets).forEach(h => {
        if (!seen[h]) seen[h] = [];
        if (r.facets[h] && seen[h].indexOf(r.facets[h]) === -1) seen[h].push(r.facets[h]);
      });
    }));
    const list = facetNames.filter(h => seen[h] && seen[h].length > 0).map(h => ({
      name: h,
      label: cap(h),
      values: seen[h].sort(cmpValues(h))
    }));
    setFacetList(list);
    const first = tables[0] ? tables[0].heads[0] : '';
    setFirstHead(first);
    if (!sortRef.current && first) {
      setSortBy(first);
      sortTables(first);
    }
    const init = {};
    list.forEach(f => {
      init[f.name] = selRef.current[f.name] || 'All';
    });
    setSel(init);
  };
  const onChange = value => {
    setQ(value);
    apply(value);
  };
  const clearAll = () => {
    const next = {};
    Object.keys(selRef.current).forEach(k => {
      next[k] = 'All';
    });
    setSel(next);
    setQ('');
    apply('');
    if (searchRef.current) searchRef.current.focus();
  };
  useEffect(() => {
    const tables = scan();
    deriveFacets(tables);
    const total = apply('');
    let retryTimer;
    if (total === 0) {
      retryTimer = setTimeout(() => {
        tablesRef.current = null;
        if (apply(qRef.current) > 0) deriveFacets(tablesRef.current); else setDisabled(true);
      }, 500);
    }
    const onKey = e => {
      if (e.key === 'Escape' && menuOpenRef.current !== null) closeMenu(menuOpenRef.current);
      if (!searchRef.current) return;
      if (e.metaKey || e.ctrlKey || e.altKey) return;
      const active = document.activeElement;
      const tag = active && active.tagName;
      const editable = active && active.isContentEditable;
      const interactive = tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT' || tag === 'BUTTON' || tag === 'A' || editable || active && active.getAttribute && active.getAttribute('role');
      if (e.key === '/' && !interactive) {
        const r = rootRef.current ? rootRef.current.getBoundingClientRect() : null;
        if (r && r.bottom > 0 && r.top < (window.innerHeight || 0)) {
          e.preventDefault();
          setMenu(null);
          searchRef.current.focus();
        }
      }
      if (e.key === 'Escape' && menuOpenRef.current === null && active === searchRef.current) {
        onChange('');
        searchRef.current.blur();
      }
    };
    const onDocClick = e => {
      const open = menuOpenRef.current;
      if (open !== null && menuRef.current[open] && !menuRef.current[open].contains(e.target)) setMenu(null);
    };
    window.addEventListener('keydown', onKey);
    document.addEventListener('mousedown', onDocClick);
    return () => {
      if (retryTimer) clearTimeout(retryTimer);
      window.removeEventListener('keydown', onKey);
      document.removeEventListener('mousedown', onDocClick);
      (tablesRef.current || []).forEach(t => {
        t.box.style.display = '';
        t.rows.forEach(row => {
          row.el.style.display = '';
        });
      });
    };
  }, []);
  useEffect(() => {
    if (menuOpen !== null) focusSelected(menuOpen);
  }, [menuOpen]);
  if (disabled) return null;
  const facetActive = Object.keys(sel).some(h => sel[h] && sel[h] !== 'All');
  const sortOptions = [firstHead].concat(facetList.map(f => f.name)).filter((h, i, a) => h && a.indexOf(h) === i);
  return <>
      <style>{`
        .sf-root {
          --sf-accent: #D97757;
          --sf-bg: #fff;
          --sf-border: #E8E6DC;
          --sf-text: #141413;
          --sf-text-3: #73726C;
          --sf-text-4: #9C9A92;
        }
        .dark .sf-root {
          --sf-bg: #1a1918;
          --sf-border: #3a3936;
          --sf-text: #e8e6dc;
          --sf-text-3: #9c9a92;
          --sf-text-4: #73726c;
        }
        .sf-root .sf-end {
          position: absolute;
          right: 10px;
          top: 50%;
          transform: translateY(-50%);
        }
        .sf-root .sf-x {
          background: none;
          border: none;
          cursor: pointer;
          color: var(--sf-text-3);
          font-size: 14px;
          padding: 2px 4px;
          line-height: 1;
        }
      `}</style>
      <div ref={rootRef} className="sf-root" style={{
    margin: '16px 0 8px'
  }}>
        <div style={{
    display: 'flex',
    gap: '8px',
    flexWrap: 'wrap',
    alignItems: 'center'
  }}>
        <div style={{
    position: 'relative',
    flex: '1 1 260px',
    maxWidth: '480px'
  }}>
          <input ref={searchRef} value={q} onChange={e => onChange(e.target.value)} placeholder={placeholderText} aria-label={placeholderText} style={{
    width: '100%',
    padding: '8px 56px 8px 12px',
    borderRadius: '8px',
    border: '1px solid var(--sf-border)',
    background: 'var(--sf-bg)',
    color: 'var(--sf-text)',
    fontSize: '14px',
    outline: 'none',
    boxSizing: 'border-box'
  }} />
          {q ? <button type="button" onClick={() => {
    onChange('');
    if (searchRef.current) searchRef.current.focus();
  }} aria-label="Clear text" className="sf-end sf-x">
              ×
            </button> : <span className="sf-end" style={{
    fontFamily: 'var(--font-mono, ui-monospace, monospace)',
    fontSize: '11px',
    color: 'var(--sf-text-4)',
    border: '1px solid var(--sf-border)',
    borderRadius: '3px',
    padding: '0 5px',
    pointerEvents: 'none'
  }}>
              /
            </span>}
        </div>
        {facetList.map(f => {
    const cur = sel[f.name] || 'All';
    const isOpen = menuOpen === f.name;
    return <div key={f.name} ref={el => {
      menuRef.current[f.name] = el;
    }} style={{
      position: 'relative'
    }}>
            <button type="button" onClick={() => setMenu(isOpen ? null : f.name)} onKeyDown={e => {
      if (e.key === 'ArrowDown') {
        e.preventDefault();
        if (!isOpen) setMenu(f.name); else focusSelected(f.name);
      }
    }} aria-haspopup="listbox" aria-expanded={isOpen} style={{
      display: 'flex',
      alignItems: 'center',
      gap: '8px',
      padding: cur !== 'All' ? '8px 30px 8px 12px' : '8px 12px',
      borderRadius: '8px',
      border: '1px solid ' + (cur !== 'All' ? 'var(--sf-accent)' : 'var(--sf-border)'),
      background: 'var(--sf-bg)',
      color: cur === 'All' ? 'var(--sf-text-3)' : 'var(--sf-text)',
      fontSize: '13.5px',
      cursor: 'pointer',
      whiteSpace: 'nowrap',
      maxWidth: '260px'
    }}>
              <span style={{
      overflow: 'hidden',
      textOverflow: 'ellipsis'
    }}>
                {f.label + ': ' + optionLabel(f, cur)}
              </span>
              <span aria-hidden="true" style={{
      fontSize: '9px',
      color: 'var(--sf-text-4)',
      transform: isOpen ? 'rotate(180deg)' : 'none',
      transition: 'transform 120ms'
    }}>
                ▼
              </span>
            </button>
            {cur !== 'All' && <button type="button" onClick={() => setFacet(f.name, 'All')} aria-label={'Clear ' + f.label + ' filter'} title={'Clear ' + f.label + ' filter'} className="sf-end sf-x">
                ×
              </button>}
            {isOpen && <div role="listbox" aria-label={f.label} onKeyDown={e => {
      const items = [...e.currentTarget.querySelectorAll('button')];
      const idx = items.indexOf(document.activeElement);
      if (e.key === 'ArrowDown') {
        e.preventDefault();
        (items[idx + 1] || items[0]).focus();
      } else if (e.key === 'ArrowUp') {
        e.preventDefault();
        (items[idx - 1] || items[items.length - 1]).focus();
      } else if (e.key === 'Home') {
        e.preventDefault();
        if (items[0]) items[0].focus();
      } else if (e.key === 'End') {
        e.preventDefault();
        if (items[items.length - 1]) items[items.length - 1].focus();
      } else if (e.key === 'Tab') {
        closeMenu(f.name);
      }
    }} style={{
      position: 'absolute',
      top: 'calc(100% + 6px)',
      left: 0,
      zIndex: 1000,
      minWidth: '260px',
      maxHeight: '340px',
      overflowY: 'auto',
      background: 'var(--sf-bg)',
      border: '1px solid var(--sf-border)',
      borderRadius: '10px',
      boxShadow: '0 8px 24px rgba(0,0,0,0.12)',
      padding: '5px'
    }}>
                {['All'].concat(f.values).map(c => {
      const selected = cur === c;
      return <button key={c} role="option" aria-selected={selected} tabIndex={-1} onClick={() => setFacet(f.name, c)} style={{
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        width: '100%',
        textAlign: 'left',
        padding: '7px 10px',
        borderRadius: '6px',
        border: 'none',
        background: 'transparent',
        color: selected ? 'var(--sf-accent)' : 'var(--sf-text)',
        fontWeight: selected ? 600 : 400,
        fontSize: '13.5px',
        cursor: 'pointer'
      }}>
                      <span aria-hidden="true" style={{
        width: '14px',
        color: 'var(--sf-accent)',
        flexShrink: 0
      }}>
                        {selected ? '✓' : ''}
                      </span>
                      {optionLabel(f, c)}
                    </button>;
    })}
              </div>}
          </div>;
  })}
        {sortOptions.length > 1 && <div role="group" aria-label="Sort by" style={{
    display: 'flex',
    alignItems: 'center',
    gap: '4px',
    fontSize: '13px',
    color: 'var(--sf-text-3)',
    whiteSpace: 'nowrap'
  }}>
            <span style={{
    marginRight: '4px'
  }}>Sort by</span>
            {sortOptions.map(o => {
    const on = sortBy === o;
    return <button key={o} type="button" aria-pressed={on} onClick={() => {
      setSortBy(o);
      sortTables(o);
    }} style={{
      padding: '6px 10px',
      borderRadius: '8px',
      border: '1px solid ' + (on ? 'var(--sf-accent)' : 'var(--sf-border)'),
      background: 'var(--sf-bg)',
      color: on ? 'var(--sf-text)' : 'var(--sf-text-3)',
      fontSize: '13px',
      cursor: 'pointer'
    }}>
                  {o.charAt(0).toUpperCase() + o.slice(1)}
                </button>;
  })}
          </div>}
        </div>
        <div aria-live="polite" style={{
    margin: '8px 0 0',
    fontSize: '13px',
    color: 'var(--sf-text-3)',
    minHeight: '1px'
  }}>
          {q.trim() === '' && !facetActive ? <>{counts.total} {nounText}</> : counts.shown === 0 ? <>
                {q.trim() === '' ? 'No ' + nounText + ' match the selected filters.' : facetActive ? 'No ' + nounText + ' match \u201c' + q + '\u201d with the selected filters.' : 'No ' + nounText + ' match \u201c' + q + '\u201d.'}{' '}
                <button type="button" onClick={clearAll} style={{
    background: 'none',
    border: 'none',
    padding: 0,
    color: 'var(--sf-accent)',
    cursor: 'pointer',
    font: 'inherit',
    textDecoration: 'underline'
  }}>
                  Clear filters
                </button>
                {children ? <> {children}</> : null}
              </> : <>
                Showing {counts.shown} of {counts.total} {nounText}
              </>}
        </div>
      </div>
    </>;
};

<BackToIndex href="#all-settings" label="Back to index" />

このリファレンスページでは、Claude Code が設定ファイルから読み込む各キーと、代わりに `~/.claude.json` に保持する[短いキーグループ](#global-config-settings)を一覧表示しています。ファイルを選択するか、優先順位を確認するには、[設定ファイルと優先順位](/docs/ja/settings)から始めてください。

<span id="available-settings" />

<span id="scopes" />

<span id="all-settings" />

<h2 id="settings-index">
  設定インデックス
</h2>

以下の各キーは、それぞれの項目にリンクしています。Scope 列には、そのキーを記述できる[ファイル](/docs/ja/settings#settings-files-and-who-they-affect)が示されています。`User` は `~/.claude/settings.json`、`Project` は `.claude/settings.json`、`Local` は `.claude/settings.local.json`、`Managed` は[組織がデプロイするもの](/docs/ja/managed-settings)です。`Any file` はこの 4 つすべてを意味し、`Global config` は [`~/.claude.json`](#global-config-settings) を意味します。

<ReferenceFilter
  noun="設定"
  placeholder="キーまたは用途で設定を絞り込む"
  facetOrder={{ scope: ["Any file", "User, local, or managed", "User or managed", "Managed", "Global config"] }}
  columnHelp={{
topic: "その項目が記載されているこのページのセクションです。Sort by を使うと、表をトピックごとにグループ化できます。",
scope: "そのキーを設定できる設定ファイル：user（~/.claude/settings.json）、project（.claude/settings.json）、local（.claude/settings.local.json）、または managed（組織がデプロイ）。Global config のキーは代わりに ~/.claude.json に記述します。",
}}
/>

| Key | Description | Topic | Scope |
| :- | :- | :- | :- |
| [`advisorModel`](#advisormodel) | Claude が [advisor ツール](/docs/ja/advisor)に問い合わせたときに応答するモデルを選択します | モデルと応答 | Any file |
| [`agent`](#agent) | すべてのセッションを、そのプロンプト、ツール、モデルを備えた名前付き[サブエージェント](/docs/ja/sub-agents)として開始します | エージェント、セッション、worktree | Any file |
| [`agentPushNotifEnabled`](#agentpushnotifenabled) | Claude が判断したときに[スマートフォンへのプッシュ通知](/docs/ja/remote-control#mobile-push-notifications)を送信できるようにします | リモート、デスクトップ、通知 | Any file |
| [`allowAllClaudeAiMcps`](#allowallclaudeaimcps) | デプロイされた [`managed-mcp.json`](/docs/ja/managed-mcp#exclusive-control-with-managed-mcp-json) と並行して、Claude Code が自ら取得する [claude.ai コネクタ](/docs/ja/mcp)を読み込みます | MCP | Managed |
| [`allowClaudeInChromeWithManagedMcp`](#allowclaudeinchromewithmanagedmcp) | デプロイされた [`managed-mcp.json`](/docs/ja/managed-mcp#exclusive-control-with-managed-mcp-json) と並行して、組み込みの [Claude in Chrome](/docs/ja/chrome) サーバーを実行できるようにします | MCP | Managed |
| [`allowedChannelPlugins`](#allowedchannelplugins) | メッセージをプッシュできる[チャネルプラグイン](/docs/ja/channels#restrict-which-channel-plugins-can-run)のデフォルトの許可リストを置き換えます | プラグインとスキル | Managed |
| [`allowedHttpHookUrls`](#allowedhttphookurls) | [HTTP フック](/docs/ja/hooks)が送信先にできる URL を制限します | フックと自動化 | Any file |
| [`allowedMcpServers`](#allowedmcpservers) | ユーザーが追加できる [MCP サーバー](/docs/ja/mcp)の許可リストを指定します | MCP | Any file |
| [`allowedProviders`](#allowedproviders) | マシンが使用できる [API プロバイダー](/docs/ja/third-party-integrations)を制限します | 認証とプロバイダー | Managed |
| [`allowManagedHooksOnly`](#allowmanagedhooksonly) | 組織がデプロイした[フック](/docs/ja/hooks)のみを実行します | フックと自動化 | Managed |
| [`allowManagedMcpServersOnly`](#allowmanagedmcpserversonly) | 管理された [MCP](/docs/ja/mcp) 許可リストのみが適用されるようにします | MCP | Managed |
| [`allowManagedPermissionRulesOnly`](#allowmanagedpermissionrulesonly) | [管理設定](/docs/ja/managed-settings)を[権限ルール](/docs/ja/permissions#managed-settings)の唯一の設定ソースにします | 権限設定 | Managed |
| [`alwaysThinkingEnabled`](#alwaysthinkingenabled) | すべてのセッションで[拡張思考](/docs/ja/model-config#extended-thinking)をオフにします | モデルと応答 | Any file |
| [`apiKeyHelper`](#apikeyhelper) | 独自のコマンドで [API 認証情報](/docs/ja/authentication#credential-management)を生成します | 認証とプロバイダー | Any file |
| [`askUserQuestionTimeout`](#askuserquestiontimeout) | 回答されていない質問が、アイドル時間の経過後に[自動的に続行](/docs/ja/tools-reference#question-auto-continue-timeout)されるようにします | インターフェースとターミナル | User or managed |
| [`appendPlugins`](#appendplugins) | ユーザーがインストールしたすべての mod の後に、組織の [mod](/docs/ja/plugins/mods/admin) を実行します | プラグインとスキル | User or managed |
| [`attribution`](#attribution) | Claude Code がコミットとプルリクエストに追加する帰属表示をカスタマイズします | Git と帰属表示 | Any file |
| [`attribution.commit`](#attribution-commit) | Claude Code がコミットに追加するトレーラーを変更または非表示にします | Git と帰属表示 | Any file |
| [`attribution.pr`](#attribution-pr) | プルリクエストの説明にある帰属表示行を変更または非表示にします | Git と帰属表示 | Any file |
| [`attribution.sessionUrl`](#attribution-sessionurl) | [クラウド](/docs/ja/claude-code-on-the-web)および [Remote Control](/docs/ja/remote-control) のコミットから claude.ai のセッションリンクを省きます | Git と帰属表示 | Any file |
| [`autoCompactEnabled`](#autocompactenabled) | [自動圧縮](/docs/ja/context-window)をオフまたはオンにします | メモリとコンテキスト | Any file |
| [`autoCompactWindow`](#autocompactwindow) | Claude Code が[圧縮](/docs/ja/context-window)を行う前にコンテキストがどの程度埋まるかを設定します | メモリとコンテキスト | Any file |
| [`autoConnectIde`](#autoconnectide) | 外部ターミナルから、実行中の [VS Code](/docs/ja/vs-code) または [JetBrains](/docs/ja/jetbrains#from-external-terminals) IDE に自動的に接続します | グローバル設定 | Global config |
| [`autoContinueAtUsageLimit`](#autocontinueatusagelimit) | 開いているセッションで待機し、claude.ai の使用制限がリセットされた後に[タスクを自動的に続行](/docs/ja/interactive-mode#wait-for-a-usage-limit-to-reset)します | インターフェースとターミナル | User or managed |
| [`autoInstallIdeExtension`](#autoinstallideextension) | VS Code のターミナルからの [IDE 拡張機能](/docs/ja/vs-code#install-the-extension)の自動インストールをオフにします | グローバル設定 | Global config |
| [`autoMemoryDirectory`](#automemorydirectory) | [自動メモリ](/docs/ja/memory#auto-memory)を任意のディレクトリに保存します | メモリとコンテキスト | Any file |
| [`autoMemoryEnabled`](#automemoryenabled) | [自動メモリ](/docs/ja/memory#auto-memory)をオフまたはオンにします | メモリとコンテキスト | Any file |
| [`autoMode`](#automode) | [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)の分類器に独自の許可ルールと拒否ルールを追加します | 権限設定 | User or managed |
| [`autoMode.classifyAllShell`](#automode-classifyallshell) | 限定的な許可ルールに一致するものも含め、すべてのシェルコマンドを [auto モードの分類器](/docs/ja/permission-modes#what-the-classifier-blocks-by-default)に送ります | 権限設定 | User or managed |
| [`autoScrollEnabled`](#autoscrollenabled) | フルスクリーンレンダリングで[新しい出力に追従](/docs/ja/fullscreen#auto-follow)して最下部までスクロールします | インターフェースとターミナル | Any file |
| [`autoUpdatesChannel`](#autoupdateschannel) | latest ではなく stable の[リリースチャネル](/docs/ja/setup#configure-release-channel)に従います | 更新とバージョン管理 | Any file |
| [`availableModels`](#availablemodels) | ユーザーが選択できる[モデルを制限](/docs/ja/model-config#restrict-model-selection)します | モデルと応答 | Any file |
| [`availableModelsMatch`](#availablemodelsmatch) | `availableModels` の各モデル ID エントリが、[その名前が示すバージョンのみを許可](/docs/ja/model-config#block-specific-models-or-versions)するようにします | モデルと応答 | Managed |
| [`awaySummaryEnabled`](#awaysummaryenabled) | ターミナルに戻ったときに表示される[セッションの要約](/docs/ja/interactive-mode#session-recap)をオフにします | リモート、デスクトップ、通知 | Any file |
| [`awsAuthRefresh`](#awsauthrefresh) | 独自のコマンドで、`.aws` 内の期限切れの [Bedrock 認証情報](/docs/ja/amazon-bedrock#advanced-credential-configuration)を更新します | 認証とプロバイダー | Any file |
| [`awsCredentialExport`](#awscredentialexport) | 独自のコマンドから [Bedrock 認証情報](/docs/ja/amazon-bedrock#advanced-credential-configuration)を JSON として提供します | 認証とプロバイダー | Any file |
| [`axScreenReader`](#axscreenreader) | [スクリーンリーダーに適した出力](/docs/ja/accessibility)をレンダリングします | インターフェースとターミナル | Any file |
| [`bashEditDiffEnabled`](#basheditdiffenabled) | すべての権限モードで、[Bash コマンドの実行中に変更されたファイル](/docs/ja/hooks#bash)を記録します | インターフェースとターミナル | User or managed |
| [`bashOutputMaxChars`](#bashoutputmaxchars) | 成功したコマンドの[出力](/docs/ja/tools-reference#output-limits)のうち、Claude がインラインで受け取る量を設定します | メモリとコンテキスト | Any file |
| [`blockedMarketplaces`](#blockedmarketplaces) | 組織に対して[プラグインマーケットプレイス](/docs/ja/plugins/overview)のソースをブロックします | プラグインとスキル | Managed |
| [`browserExternalPageTools`](#browserexternalpagetools) | [デスクトップ](/docs/ja/desktop)の Browser ペインで、Claude のツールが外部ページで動作しないようにします | ツール | Managed |
| [`channelsEnabled`](#channelsenabled) | 組織で[チャネル](/docs/ja/channels#enable-channels-for-your-organization)を許可します | プラグインとスキル | Managed |
| [`claudeInChromeDefaultEnabled`](#claudeinchromedefaultenabled) | 対話型 CLI と VS Code 拡張機能で、セッションの開始時に [Chrome 統合](/docs/ja/chrome)をオンにします | グローバル設定 | Global config |
| [`claudeMd`](#claudemd) | 管理設定から組織全体の [CLAUDE.md](/docs/ja/memory#deploy-organization-wide-claude-md) の指示を注入します | メモリとコンテキスト | Managed |
| [`claudeMdExcludes`](#claudemdexcludes) | メモリの読み込み時に特定の [CLAUDE.md](/docs/ja/memory#exclude-specific-claude-md-files) ファイルをスキップします | メモリとコンテキスト | Any file |
| [`cleanupPeriodDays`](#cleanupperioddays) | Claude Code が[トランスクリプト](/docs/ja/data-usage#data-retention)を削除するまで保持する日数を選択します | プライバシーとテレメトリ | Any file |
| [`companyAnnouncements`](#companyannouncements) | 起動時に組織のお知らせを表示します | インターフェースとターミナル | Any file |
| [`copyFullResponse`](#copyfullresponse) | [`/copy`](/docs/ja/commands) がコードブロックの選択画面を表示せずに応答全体をコピーするようにします | グローバル設定 | Global config |
| [`copyOnSelect`](#copyonselect) | [フルスクリーンレンダリング](/docs/ja/fullscreen#use-the-mouse)とエージェントビューで、マウスで選択したテキストの自動コピーをオフにします | グローバル設定 | Global config |
| [`crossSessionInbound`](#crosssessioninbound) | Claude Code が[他のセッションからのメッセージ](/docs/ja/cross-session-messaging#control-inbound-messages)を配信するか、配信せずに通知を表示するか、拒否するかを選択します | エージェント、セッション、worktree | Any file |
| [`defaultShell`](#defaultshell) | [`!` プレフィックス](/docs/ja/interactive-mode#shell-mode-with-prefix)で入力したシェルコマンドを Bash と PowerShell のどちらで実行するかを選択します | インターフェースとターミナル | Any file |
| [`defaultToAgentsView`](#defaulttoagentsview) | 引数なしで `claude` を実行したときに、新しい会話ではなく[エージェントビュー](/docs/ja/agent-view)を開きます | グローバル設定 | Global config |
| [`deniedMcpServers`](#deniedmcpservers) | URL、コマンド、または名前で特定の [MCP サーバー](/docs/ja/mcp)をブロックします | MCP | Any file |
| [`deniedModels`](#deniedmodels) | `availableModels` で許可されているものも含め、[特定のモデルをブロック](/docs/ja/model-config#block-specific-models-or-versions)します | モデルと応答 | Managed |
| [`desktopSessionCleanupPeriodDays`](#desktopsessioncleanupperioddays) | [Claude Desktop と Cowork のトランスクリプト](/docs/ja/claude-directory#cleaned-up-automatically)の保持期間の上限を日数で設定します | プライバシーとテレメトリ | User or managed |
| [`dialogExpiry`](#dialogexpiry) | 転送されたダイアログに [Remote Control](/docs/ja/remote-control) または SDK ホストが応答するまで、Claude Code がダイアログをキャンセルせずに待機する時間を設定します | インターフェースとターミナル | User or managed |
| [`diffTool`](#difftool) | Claude が提案するファイル変更を [VS Code](/docs/ja/vs-code) または [JetBrains](/docs/ja/jetbrains#features) の差分ビューアーで開くか、ターミナルに表示したままにするかを選択します | グローバル設定 | Global config |
| [`disableAgentView`](#disableagentview) | バックグラウンドエージェントと[エージェントビュー](/docs/ja/agent-view)をオフにします | エージェント、セッション、worktree | Any file |
| [`disableAllHooks`](#disableallhooks) | [フック](/docs/ja/hooks)、カスタム[ステータスライン](/docs/ja/statusline)、カスタム [`@` ファイル候補](/docs/ja/interactive-mode#quick-commands)コマンドをまとめてオフにします | フックと自動化 | Any file |
| [`disableArtifact`](#disableartifact) | 非推奨です。[Artifact ツール](/docs/ja/artifacts)をオフにするには `enableArtifact` を使用してください | リモート、デスクトップ、通知 | Any file |
| [`disableAutoMode`](#disableautomode) | 権限モードの切り替えサイクルから [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)を除外します | 権限設定 | Any file |
| [`disableBrowserExternalNavigation`](#disablebrowserexternalnavigation) | [デスクトップ](/docs/ja/desktop)の Browser ペインを、ユーザーと Claude の両方について localhost に制限します | ツール | Managed |
| [`disableBundledSkills`](#disablebundledskills) | Claude Code に含まれる[スキル](/docs/ja/skills#bundled-skills)と[ワークフロー](/docs/ja/workflows)をオフにします | プラグインとスキル | Any file |
| [`disableClaudeAiConnectors`](#disableclaudeaiconnectors) | [claude.ai コネクタ](/docs/ja/mcp#disable-claude-ai-connectors)をオフにし、Claude Code がそれらを取得しないようにします | MCP | Any file |
| [`disableCommandPluginSources`](#disablecommandpluginsources) | マーケットプレイスで宣言されたコマンドを実行してインストールする[プラグイン](/docs/ja/plugins/overview)をブロックします | プラグインとスキル | Managed |
| [`disableDeepLinkRegistration`](#disabledeeplinkregistration) | Claude Code が [`claude-cli://` ハンドラー](/docs/ja/deep-links)を登録しないようにします | リモート、デスクトップ、通知 | Any file |
| [`disableDesktopLocalSessions`](#disabledesktoplocalsessions) | デバイス上で実行される [Desktop の Code セッション](/docs/ja/desktop#local-sessions-on-managed-devices)をオフにし、他のホストへの SSH とクラウドのみを残します | リモート、デスクトップ、通知 | Managed |
| [`disabledMcpjsonServers`](#disabledmcpjsonservers) | プロジェクトの [`.mcp.json`](/docs/ja/mcp#project-scope) にある特定のサーバーを拒否します | MCP | Any file |
| [`disableMobileSimulatorTools`](#disablemobilesimulatortools) | [デスクトップ](/docs/ja/desktop)の iOS Simulator ペインで Claude のツールをブロックします | ツール | Managed |
| [`disableRemoteControl`](#disableremotecontrol) | [Remote Control](/docs/ja/remote-control) を、起動可能なすべての場所でオフにします | リモート、デスクトップ、通知 | Any file |
| [`disableSideloadFlags`](#disablesideloadflags) | [プラグイン](/docs/ja/plugins/overview)、[サブエージェント](/docs/ja/sub-agents)、[MCP サーバー](/docs/ja/mcp)をサイドロードする CLI フラグを拒否します | エンタープライズと管理設定 | Managed |
| [`disableSkillShellExecution`](#disableskillshellexecution) | [スキル](/docs/ja/skills)とカスタムコマンドがインラインでシェルを実行しないようにします | プラグインとスキル | Any file |
| [`disableWorkflows`](#disableworkflows) | [動的ワークフロー](/docs/ja/workflows)を全員に対してオフにします。自分だけに適用するには `enableWorkflows` を使用してください | フックと自動化 | Any file |
| [`editorMode`](#editormode) | 入力プロンプトで [vim キーバインド](/docs/ja/interactive-mode#vim-editor-mode)を使用します | インターフェースとターミナル | Any file |
| [`effortLevel`](#effortlevel) | 独自に保存されたレベルを持たないモデルに対して、デフォルトの [effort レベル](/docs/ja/model-config#adjust-effort-level)を設定します | モデルと応答 | Any file |
| [`emojiCompletionEnabled`](#emojicompletionenabled) | プロンプト入力での [`:shortcode:` 絵文字の候補表示と置換](/docs/ja/interactive-mode#emoji-shortcodes)をオフにします | インターフェースとターミナル | Any file |
| [`enableAllProjectMcpServers`](#enableallprojectmcpservers) | プロジェクトの [`.mcp.json`](/docs/ja/mcp#project-server-approvals-and-workspace-trust) ファイル内のすべてのサーバーを、プロンプトなしで承認します | MCP | Any file |
| [`enableArtifact`](#enableartifact) | いずれかのファイルで `false` を指定すると [Artifact ツール](/docs/ja/artifacts)をオフにします。どのファイルからも再びオンにすることはできません | リモート、デスクトップ、通知 | Any file |
| [`enabledMcpjsonServers`](#enabledmcpjsonservers) | プロジェクトの [`.mcp.json`](/docs/ja/mcp#project-server-approvals-and-workspace-trust) にある特定のサーバーを承認します | MCP | Any file |
| [`enabledPlugins`](#enabledplugins) | 個々の[プラグイン](/docs/ja/plugins/overview)をスコープごとにオンまたはオフにします | プラグインとスキル | Any file |
| [`enableWorkflows`](#enableworkflows) | プランのデフォルトに対して[動的ワークフロー](/docs/ja/workflows)をオンまたはオフにします | フックと自動化 | Any file |
| [`enforceAvailableModels`](#enforceavailablemodels) | [`/model` の Default の選択肢](/docs/ja/model-config#enforce-the-allowlist-for-the-default-model)を `availableModels` 許可リストの範囲内に保ちます | モデルと応答 | Any file |
| [`env`](#env) | すべてのセッションとそのサブプロセスに対して[環境変数](/docs/ja/env-vars#in-settings-files)を設定します | メモリとコンテキスト | Any file |
| [`externalEditorContext`](#externaleditorcontext) | [Ctrl+G](/docs/ja/interactive-mode#general-controls) を押して編集するときに、Claude の直前の応答をコメントとして表示します | グローバル設定 | Global config |
| [`extraKnownMarketplaces`](#extraknownmarketplaces) | リポジトリまたは組織に対して[マーケットプレイス](/docs/ja/plugins/overview)を登録します | プラグインとスキル | Any file |
| [`fallbackModel`](#fallbackmodel) | プライマリモデルが過負荷のときに使う[バックアップモデル](/docs/ja/model-config#fallback-model-chains)を指定します | モデルと応答 | Any file |
| [`fastMode`](#fastmode) | 利用可能なセッションで [fast mode](/docs/ja/fast-mode) をオンにします | モデルと応答 | Any file |
| [`fastModePerSessionOptIn`](#fastmodepersessionoptin) | セッションごとに [fast mode](/docs/ja/fast-mode) をオンにすることを必須にします | モデルと応答 | Any file |
| [`feedbackDrafts`](#feedbackdrafts) | Claude がレビュー用の[フィードバックの下書き](/docs/ja/tools-reference#sendfeedback-tool-behavior)をキューに入れるかどうかを制御します | プライバシーとテレメトリ | User or managed |
| [`feedbackSurveyRate`](#feedbacksurveyrate) | [セッション品質アンケート](/docs/ja/data-usage#session-quality-surveys)が表示される頻度を変更します | プライバシーとテレメトリ | Any file |
| [`fileCheckpointingEnabled`](#filecheckpointingenabled) | [`/rewind`](/docs/ja/checkpointing) が復元するファイルスナップショットをオフまたはオンにします | メモリとコンテキスト | Any file |
| [`fileSuggestion`](#filesuggestion) | 独自のコマンドから [`@` ファイルのオートコンプリート](/docs/ja/interactive-mode#quick-commands)を提供します | インターフェースとターミナル | Any file |
| [`footerLinksRegexes`](#footerlinksregexes) | 出力内の issue やレビューの ID を、入力ボックスの下にある[クリック可能なリンク](/docs/ja/statusline#clickable-links)にします | インターフェースとターミナル | User or managed |
| [`forceLoginGatewayUrl`](#forcelogingatewayurl) | ログイン画面が接続する[ゲートウェイ URL](/docs/ja/claude-apps-gateway#set-the-gateway-url) を設定します | 認証とプロバイダー | Managed |
| [`forceLoginMethod`](#forceloginmethod) | [ログインを](/docs/ja/authentication#restrict-login-to-your-organization) claude.ai、Claude Console、または[クラウドゲートウェイ](/docs/ja/claude-apps-gateway)に制限します | 認証とプロバイダー | Any file |
| [`forceLoginOrgUUID`](#forceloginorguuid) | [claude.ai のログインを組織に固定](/docs/ja/authentication#restrict-login-to-your-organization)します。これを強制できるのは管理ソースのみです | 認証とプロバイダー | Any file |
| [`forceRemoteSettingsRefresh`](#forceremotesettingsrefresh) | [サーバー管理設定](/docs/ja/server-managed-settings)が新たに取得されるまで起動をブロックします | エンタープライズと管理設定 | Managed |
| [`gatewayInternalNetworks`](#gatewayinternalnetworks) | 組織が内部で使用しているパブリック IPv4 空間上の[クラウドゲートウェイ](/docs/ja/claude-apps-gateway#allow-a-gateway-on-public-address-space-you-own)に `/login` が到達できるようにします | 認証とプロバイダー | Managed |
| [`gcpAuthRefresh`](#gcpauthrefresh) | 独自のコマンドで [Google Cloud の認証情報](/docs/ja/google-vertex-ai#advanced-credential-configuration)を更新します | 認証とプロバイダー | Any file |
| [`hooks`](#hooks) | Claude Code のライフサイクルの各時点で、独自のコマンドを[フック](/docs/ja/hooks)として実行します | フックと自動化 | Any file |
| [`httpHookAllowedEnvVars`](#httphookallowedenvvars) | [HTTP フック](/docs/ja/hooks)がヘッダーに含められる環境変数を制限します | フックと自動化 | Any file |
| [`includeCoAuthoredBy`](#includecoauthoredby) | 非推奨です。コミットと PR の帰属表示を非表示にしたり変更したりするには `attribution` を使用してください | Git と帰属表示 | Any file |
| [`includeGitInstructions`](#includegitinstructions) | 組み込みのコミットおよび PR の指示を Claude のコンテキストから除外します | Git と帰属表示 | Any file |
| [`inputNeededNotifEnabled`](#inputneedednotifenabled) | Claude がユーザーの入力を待っているときに[プッシュ通知](/docs/ja/remote-control#mobile-push-notifications)を受け取ります | リモート、デスクトップ、通知 | Any file |
| [`isolatePeerMachines`](#isolatepeermachines) | Claude が[別のマシン上の自分のセッションにメッセージを送る](/docs/ja/cross-session-messaging#require-approval-for-cross-machine-messages)前に確認を求めます | エージェント、セッション、worktree | Any file |
| [`keybindingFlavor`](#keybindingflavor) | 非推奨で、効果はありません。単語編集のショートカットは常に [readline の規則に従います](/docs/ja/interactive-mode#make-ctrl-w-delete-back-to-whitespace) | インターフェースとターミナル | Any file |
| [`language`](#language) | Claude に英語以外の言語で応答させます | モデルと応答 | Any file |
| [`leftArrowOpensAgents`](#leftarrowopensagents) | [セッションをバックグラウンドに移してエージェントビューを開く](/docs/ja/agent-view#switch-sessions-without-leaving-the-terminal) `←` ショートカットをオフにします | グローバル設定 | Global config |
| [`managedMcpServers`](#managedmcpservers) | ユーザーが追加するものに加えて、すべてのユーザーにリモート [MCP サーバー](/docs/ja/managed-mcp#provide-servers-through-managed-settings)を提供します | MCP | Managed |
| [`managedSourcesBehavior`](#managedsourcesbehavior) | 優先度が最も高いものだけを使うのではなく、デプロイしたすべての[管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)を組み合わせます | エンタープライズと管理設定 | Managed |
| [`maxEffortLevel`](#maxeffortlevel) | すべてのプロバイダーで、すべてのモデルまたはモデルごとに [effort レベル](/docs/ja/model-config#adjust-effort-level)の上限を設定します | モデルと応答 | Any file |
| [`maxProseWidth`](#maxprosewidth) | 幅の広いターミナルで、Claude の応答の文章部分の幅に上限を設定します | インターフェースとターミナル | Any file |
| [`minimumVersion`](#minimumversion) | [自動更新](/docs/ja/setup#pin-a-minimum-version)で指定バージョン未満のものがインストールされないようにします | 更新とバージョン管理 | Any file |
| [`model`](#model) | Claude Code の起動時に使用する[モデル](/docs/ja/model-config#set-a-default-model-for-new-sessions)を変更します | モデルと応答 | Any file |
| [`modelOverrides`](#modeloverrides) | [モデル ID を](/docs/ja/model-config#override-model-ids-per-version) Bedrock の ARN などのプロバイダーの ID に対応付けます | モデルと応答 | Any file |
| [`modelPicker`](#modelpicker) | [`/model` ピッカー](/docs/ja/model-config#available-models)に表示するモデルを、独自の順序とラベルで選択します | モデルと応答 | User or managed |
| [`modelPricing`](#modelpricing) | 定価ではなく、組織の契約料金で支出を報告します | モデルと応答 | Managed |
| [`modelSettings`](#modelsettings) | モデルごとに保存された [effort レベル](/docs/ja/model-config#adjust-effort-level)または[自動圧縮ウィンドウ](/docs/ja/model-config#set-the-auto-compact-window)を保持するか、特定のモデルの effort に上限を設定します | モデルと応答 | Any file |
| [`otelHeadersHelper`](#otelheadershelper) | 独自のコマンドで、ローテーションする [OpenTelemetry](/docs/ja/monitoring-usage#dynamic-headers) ヘッダーを生成します | 認証とプロバイダー | Any file |
| [`outputStyle`](#outputstyle) | [出力スタイル](/docs/ja/output-styles)で Claude の役割、トーン、出力形式を変更します | モデルと応答 | Any file |
| [`parentSettingsBehavior`](#parentsettingsbehavior) | [管理設定](/docs/ja/managed-settings)をデプロイする際に、[SDK または IDE ホスト](/docs/ja/managed-settings#let-an-embedding-host-add-policy)が渡す制限を適用するか破棄するかを指定します | エンタープライズと管理設定 | Managed |
| [`permissionExplainerEnabled`](#permissionexplainerenabled) | v2.1.257 で、シェルの権限プロンプトにおける `Ctrl+E` のコマンド説明とともに削除されました | グローバル設定 | Global config |
| [`permissions`](#permissions) | 許可ルール、確認ルール、拒否ルールと、開始時の[権限モード](/docs/ja/permission-modes)を設定します | 権限設定 | Any file |
| [`permissions.additionalDirectories`](#permissions-additionaldirectories) | [現在のディレクトリ以外のディレクトリ](/docs/ja/permissions#working-directories)へのファイルアクセスを Claude に与えます | 権限設定 | Any file |
| [`permissions.allow`](#permissions-allow) | 列挙した[ツールの使用](/docs/ja/permissions#permission-rule-syntax)をプロンプトなしで承認します | 権限設定 | Any file |
| [`permissions.ask`](#permissions-ask) | 列挙した[ツールの使用](/docs/ja/permissions#permission-rule-syntax)の前に常にプロンプトを表示します | 権限設定 | Any file |
| [`permissions.blockReadsOutsideWorkingDirectories`](#permissions-blockreadsoutsideworkingdirectories) | すべての権限モードで、ファイルツールが[作業ディレクトリ](/docs/ja/permissions#working-directories)外の読み取りを拒否するようにします | 権限設定 | Any file |
| [`permissions.defaultMode`](#permissions-defaultmode) | 新しいセッションの開始時の[権限モード](/docs/ja/permission-modes#which-mode-a-session-starts-in)を設定します | 権限設定 | Any file |
| [`permissions.deny`](#permissions-deny) | シークレットを保持するファイルの読み取りを含め、列挙した[ツールの使用](/docs/ja/permissions#permission-rule-syntax)をブロックします | 権限設定 | Any file |
| [`permissions.disableBypassPermissionsMode`](#permissions-disablebypasspermissionsmode) | 誰も [bypassPermissions モード](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)に入れないようにします | 権限設定 | Any file |
| [`plansDirectory`](#plansdirectory) | [plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)がプランファイルを書き込む場所を選択します | メモリとコンテキスト | Any file |
| [`pluginConfigs`](#pluginconfigs) | [プラグイン](/docs/ja/plugins/overview)の設定ダイアログで入力した回答を保存します | プラグインとスキル | User or managed |
| [`pluginSuggestionMarketplaces`](#pluginsuggestionmarketplaces) | `/plugin` でプラグインのインストール候補を表示できる[マーケットプレイス](/docs/ja/plugins/org#restrict-what-users-can-install)を選択します | プラグインとスキル | Managed |
| [`pluginTrustMessage`](#plugintrustmessage) | [プラグイン](/docs/ja/plugins/overview)の信頼に関する警告に独自のテキストを追加します | プラグインとスキル | Managed |
| [`policyHelper`](#policyhelper) | 起動時に[管理設定](/docs/ja/managed-settings#compute-the-policy-with-a-helper-program)を算出する実行ファイルを実行します | エンタープライズと管理設定 | Managed |
| [`policyHelper.path`](#policyhelper-path) | Claude Code が実行する[ヘルパー実行ファイル](/docs/ja/managed-settings#compute-the-policy-with-a-helper-program)を指定します | エンタープライズと管理設定 | Managed |
| [`policyHelper.refreshIntervalMs`](#policyhelper-refreshintervalms) | [ヘルパー](/docs/ja/managed-settings#compute-the-policy-with-a-helper-program)をバックグラウンドで一定間隔ごとに再実行します | エンタープライズと管理設定 | Managed |
| [`policyHelper.timeoutMs`](#policyhelper-timeoutms) | Claude Code が[ヘルパー](/docs/ja/managed-settings#compute-the-policy-with-a-helper-program)を待機する時間を設定します | エンタープライズと管理設定 | Managed |
| [`preferredNotifChannel`](#preferrednotifchannel) | タスク完了時の通知として、[ターミナルベルまたはデスクトップ通知](/docs/ja/terminal-config#get-a-terminal-bell-or-notification)を選択します | リモート、デスクトップ、通知 | Any file |
| [`prefersReducedMotion`](#prefersreducedmotion) | スピナー、シマー、フラッシュのアニメーションを[抑えるかオフにします](/docs/ja/accessibility#accessibility-settings) | インターフェースとターミナル | Any file |
| [`prependPlugins`](#prependplugins) | ユーザーがインストールしたすべての mod の前に、組織の [mod](/docs/ja/plugins/mods/admin) を実行します | プラグインとスキル | User or managed |
| [`processWrapper`](#processwrapper) | macOS と Linux で、Claude Code のバックグラウンドプロセスを[企業ランチャー](/docs/ja/corporate-launcher)経由で実行します | エージェント、セッション、worktree | User or managed |
| [`promptCacheTtl`](#promptcachettl) | メインの会話の[プロンプトキャッシュの有効期間](/docs/ja/prompt-caching#cache-lifetime)を選択します | モデルと応答 | Any file |
| [`promptSuggestionEnabled`](#promptsuggestionenabled) | 入力ボックスにグレー表示される[プロンプト候補](/docs/ja/interactive-mode#prompt-suggestions)を非表示にします | インターフェースとターミナル | Any file |
| [`prStatusFooterEnabled`](#prstatusfooterenabled) | プロンプトフッターの [PR レビューステータス](/docs/ja/interactive-mode#pr-review-status)バッジと、その背後にあるプルリクエストのチェックをオフにします | グローバル設定 | Global config |
| [`prUrlTemplate`](#prurltemplate) | PR リンクの参照先を github.com ではなく社内のコードレビューツールにします | Git と帰属表示 | Any file |
| [`remote.defaultEnvironmentId`](#remote-defaultenvironmentid) | `claude --cloud` のデフォルトの[クラウド環境](/docs/ja/cloud-environments)を選択します。セルフホストの `ccpool_` ID は、ユーザー設定、管理設定、`--settings` からのみ読み取られます | リモート、デスクトップ、通知 | Any file |
| [`remoteControlAtStartup`](#remotecontrolatstartup) | セッションの開始時に [Remote Control](/docs/ja/remote-control#enable-remote-control-for-all-sessions) に自動的に接続します | リモート、デスクトップ、通知 | Any file |
| [`requiredMaximumVersion`](#requiredmaximumversion) | 組織が許可するバージョンより新しいバージョンでは[起動を拒否](/docs/ja/setup#pin-a-minimum-version)します | 更新とバージョン管理 | Managed |
| [`requiredMinimumVersion`](#requiredminimumversion) | 組織が要求するバージョンより古いバージョンでは[起動を拒否](/docs/ja/setup#pin-a-minimum-version)します | 更新とバージョン管理 | Managed |
| [`respectGitignore`](#respectgitignore) | gitignore されたファイルを [`@` ファイルピッカー](/docs/ja/interactive-mode#quick-commands)から除外します | インターフェースとターミナル | Any file |
| [`respondToBashCommands`](#respondtobashcommands) | [`!` シェルコマンド](/docs/ja/interactive-mode#shell-mode-with-prefix)の実行後に Claude が応答しないようにします | インターフェースとターミナル | Any file |
| [`sandbox`](#sandbox) | macOS、Linux、WSL2 で、[Bash コマンドを](/docs/ja/sandboxing)ファイルシステムやネットワークから隔離します | サンドボックス設定 | Any file |
| [`sandbox.allowAppleEvents`](#sandbox-allowappleevents) | macOS で、[サンドボックス化](/docs/ja/sandboxing)されたコマンドが Apple Events を送信できるようにします | サンドボックス設定 | User or managed |
| [`sandbox.allowUnsandboxedCommands`](#sandbox-allowunsandboxedcommands) | ブロックされたコマンドを Claude が[サンドボックス](/docs/ja/sandboxing#the-unsandboxed-retry-escape-hatch)外で再試行できるようにするか、禁止します | サンドボックス設定 | Any file |
| [`sandbox.autoAllowBashIfSandboxed`](#sandbox-autoallowbashifsandboxed) | [サンドボックス化](/docs/ja/sandboxing#auto-allow-mode)されたコマンドを権限プロンプトなしで実行します | サンドボックス設定 | Any file |
| [`sandbox.bwrapPath`](#sandbox-bwrappath) | [サンドボックス](/docs/ja/sandboxing)が `PATH` 外にある bubblewrap バイナリを使用するよう指定します | サンドボックス設定 | Managed |
| [`sandbox.credentials`](#sandbox-credentials) | [サンドボックス](/docs/ja/sandboxing#protect-credentials)内で認証情報ファイルや変数を非表示にするかマスクします | サンドボックス設定 | Any file |
| [`sandbox.credentials.allowPlaintextInject`](#sandbox-credentials-allowplaintextinject) | 信頼できるテストネットワーク上で、[マスクされた認証情報](/docs/ja/sandboxing#mask-credentials)がプレーンな HTTP サービスに届くようにします | サンドボックス設定 | User or managed |
| [`sandbox.credentials.awsPairs`](#sandbox-credentials-awspairs) | カスタム名の AWS キー変数を、[再署名](/docs/ja/sandboxing#re-sign-aws-requests)用に 1 つの認証情報として関連付けます | サンドボックス設定 | User or managed |
| [`sandbox.credentials.envVars`](#sandbox-credentials-envvars) | [サンドボックス](/docs/ja/sandboxing#mask-environment-variables)内で環境変数を未設定にするかマスクします | サンドボックス設定 | Any file |
| [`sandbox.credentials.files`](#sandbox-credentials-files) | [サンドボックス](/docs/ja/sandboxing#mask-credential-files)内で認証情報ファイルの読み取りをブロックするかマスクします | サンドボックス設定 | Any file |
| [`sandbox.credentials.sigv4`](#sandbox-credentials-sigv4) | ストリーミング、署名付き、または [SigV4A の AWS リクエスト](/docs/ja/sandboxing#re-sign-aws-requests)を失敗させるか通過させるかを選択します | サンドボックス設定 | User or managed |
| [`sandbox.enabled`](#sandbox-enabled) | macOS、Linux、WSL2 で [Bash のサンドボックス化](/docs/ja/sandboxing#get-started)をオンにします | サンドボックス設定 | Any file |
| [`sandbox.enableWeakerNestedSandbox`](#sandbox-enableweakernestedsandbox) | 非特権コンテナ内で Linux の[サンドボックス](/docs/ja/sandboxing)を実行します | サンドボックス設定 | Any file |
| [`sandbox.enableWeakerNetworkIsolation`](#sandbox-enableweakernetworkisolation) | macOS の[サンドボックス](/docs/ja/sandboxing#go-based-clis-fail-tls-verification-on-macos)内で、`gh`、`gcloud`、`terraform` が MITM プロキシ経由で TLS を検証できるようにします | サンドボックス設定 | Any file |
| [`sandbox.excludedCommands`](#sandbox-excludedcommands) | Claude Code が[サンドボックス](/docs/ja/sandboxing)外で実行できるコマンドを指定します | サンドボックス設定 | Any file |
| [`sandbox.failIfUnavailable`](#sandbox-failifunavailable) | [サンドボックス](/docs/ja/sandboxing)を開始できない場合、サンドボックスなしで実行するのではなく起動を拒否します | サンドボックス設定 | Any file |
| [`sandbox.filesystem`](#sandbox-filesystem) | [サンドボックス化](/docs/ja/sandboxing#filesystem-isolation)されたコマンドが読み書きできるパスを制御します | サンドボックス設定 | Any file |
| [`sandbox.filesystem.allowManagedReadPathsOnly`](#sandbox-filesystem-allowmanagedreadpathsonly) | [組織がブロックした読み取りパス](/docs/ja/sandboxing#keep-developers-from-widening-the-policy)を開発者が再び開けないようにします | サンドボックス設定 | Managed |
| [`sandbox.filesystem.allowRead`](#sandbox-filesystem-allowread) | [`denyRead`](#sandbox-filesystem-denyread) がブロックする領域内で読み取りを再び許可します | サンドボックス設定 | Any file |
| [`sandbox.filesystem.allowWrite`](#sandbox-filesystem-allowwrite) | [サンドボックス化](/docs/ja/sandboxing)されたコマンドが書き込めるパスを追加します | サンドボックス設定 | Any file |
| [`sandbox.filesystem.denyRead`](#sandbox-filesystem-denyread) | [サンドボックス化](/docs/ja/sandboxing)されたコマンドが特定のパスを読み取らないようブロックします | サンドボックス設定 | Any file |
| [`sandbox.filesystem.denyWrite`](#sandbox-filesystem-denywrite) | [サンドボックス化](/docs/ja/sandboxing)されたコマンドが特定のパスに書き込まないようブロックします | サンドボックス設定 | Any file |
| [`sandbox.filesystem.disabled`](#sandbox-filesystem-disabled) | ネットワークの隔離を維持したまま、[ファイルシステムの隔離をオフにします](/docs/ja/sandboxing#disable-filesystem-isolation) | サンドボックス設定 | User or managed |
| [`sandbox.ignoreViolations`](#sandbox-ignoreviolations) | コマンドが調べることが想定されているパスについて、違反レポートを抑制します | サンドボックス設定 | Any file |
| [`sandbox.network`](#sandbox-network) | [サンドボックス化](/docs/ja/sandboxing#network-isolation)されたコマンドが到達できるホスト、ポート、ソケットを制御します | サンドボックス設定 | Any file |
| [`sandbox.network.allowAllUnixSockets`](#sandbox-network-allowallunixsockets) | [サンドボックス化](/docs/ja/sandboxing)されたコマンドがすべての Unix ソケットに接続できるようにします | サンドボックス設定 | Any file |
| [`sandbox.network.allowedDomains`](#sandbox-network-alloweddomains) | ドメインを事前に許可し、[サンドボックス化](/docs/ja/sandboxing)されたコマンドがそれらについてプロンプトを表示しないようにします | サンドボックス設定 | Any file |
| [`sandbox.network.allowLocalBinding`](#sandbox-network-allowlocalbinding) | macOS で、[サンドボックス化](/docs/ja/sandboxing)されたコマンドがネットワークポートでリッスンし、localhost に接続できるようにします | サンドボックス設定 | Any file |
| [`sandbox.network.allowMachLookup`](#sandbox-network-allowmachlookup) | iOS Simulator や Playwright などの macOS の[サンドボックス化](/docs/ja/sandboxing)されたツールが、それぞれの XPC サービスに到達できるようにします | サンドボックス設定 | Any file |
| [`sandbox.network.allowManagedDomainsOnly`](#sandbox-network-allowmanageddomainsonly) | ネットワークの許可リストを[管理設定](/docs/ja/sandboxing#keep-developers-from-widening-the-policy)に固定します | サンドボックス設定 | Managed |
| [`sandbox.network.allowUnixSockets`](#sandbox-network-allowunixsockets) | macOS で、[サンドボックス化](/docs/ja/sandboxing)されたコマンドが使用できる Unix ソケットのパスを列挙します | サンドボックス設定 | Any file |
| [`sandbox.network.deniedDomains`](#sandbox-network-denieddomains) | 許可されたワイルドカード内であっても、[サンドボックス化](/docs/ja/sandboxing)されたコマンドに対してドメインをブロックします | サンドボックス設定 | Any file |
| [`sandbox.network.httpProxyPort`](#sandbox-network-httpproxyport) | [サンドボックス](/docs/ja/sandboxing#custom-proxy-configuration)の HTTP トラフィックを独自のプロキシ経由でルーティングします | サンドボックス設定 | Any file |
| [`sandbox.network.socksProxyPort`](#sandbox-network-socksproxyport) | [サンドボックス](/docs/ja/sandboxing#custom-proxy-configuration)の SOCKS トラフィックを独自のプロキシ経由でルーティングします | サンドボックス設定 | Any file |
| [`sandbox.network.strictAllowlist`](#sandbox-network-strictallowlist) | [許可リスト](/docs/ja/sandboxing#network-isolation)外のホストを、プロンプトを表示せずに拒否します | サンドボックス設定 | User or managed |
| [`sandbox.network.tlsTerminate`](#sandbox-network-tlsterminate) | [サンドボックス](/docs/ja/sandboxing#network-isolation)のプロキシで TLS を終端し、HTTPS リクエストを読み取れるようにします | サンドボックス設定 | User or managed |
| [`sandbox.ripgrep`](#sandbox-ripgrep) | [サンドボックス](/docs/ja/sandboxing)内で独自の ripgrep バイナリを使用します | サンドボックス設定 | User or managed |
| [`sandbox.socatPath`](#sandbox-socatpath) | [サンドボックス](/docs/ja/sandboxing)のプロキシが `PATH` 外にある `socat` バイナリを使用するよう指定します | サンドボックス設定 | Managed |
| [`showClearContextOnPlanAccept`](#showclearcontextonplanaccept) | [プランの承認画面](/docs/ja/permission-modes#review-and-approve-a-plan)に「コンテキストをクリア」オプションを表示します | インターフェースとターミナル | Any file |
| [`showThinkingSummaries`](#showthinkingsummaries) | 折りたたまれた表示ではなく、Claude の[思考](/docs/ja/model-config#extended-thinking)の要約を表示します | モデルと応答 | Any file |
| [`showTurnDuration`](#showturnduration) | 各応答の後に表示される「Cooked for」の所要時間を非表示にします | インターフェースとターミナル | Any file |
| [`skillListingBudgetFraction`](#skilllistingbudgetfraction) | [スキル一覧](/docs/ja/skills#skill-descriptions-are-cut-short)に確保するコンテキストを増減します | メモリとコンテキスト | Any file |
| [`skillListingMaxDescChars`](#skilllistingmaxdescchars) | [スキル一覧](/docs/ja/skills#skill-descriptions-are-cut-short)における各スキルの説明の長さに上限を設定します | メモリとコンテキスト | Any file |
| [`skillOverrides`](#skilloverrides) | SKILL.md を編集せずに[スキルを非表示にするか折りたたみます](/docs/ja/skills#override-skill-visibility-from-settings) | プラグインとスキル | Any file |
| [`skipAutoPermissionPrompt`](#skipautopermissionprompt) | 組み込みのデフォルトではなく自分で初めて [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)に入ったときに Claude Code が表示する 1 回限りの通知をスキップします | 権限設定 | User or managed |
| [`skipDangerousModePermissionPrompt`](#skipdangerousmodepermissionprompt) | [bypassPermissions モード](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)に入る前の確認ダイアログをスキップします | 権限設定 | User, local, or managed |
| [`skipWebFetchPreflight`](#skipwebfetchpreflight) | Anthropic に到達できない場合に、[WebFetch のホスト名チェック](/docs/ja/tools-reference#webfetch-tool-behavior)をスキップします | プライバシーとテレメトリ | Any file |
| [`spellcheck`](#spellcheck) | インストールした[スペルチェッカー](/docs/ja/interactive-mode#check-spelling-as-you-type)で、プロンプト入力内のスペルミスに下線を引きます | インターフェースとターミナル | User or managed |
| [`spinnerTipsEnabled`](#spinnertipsenabled) | Claude の作業中にスピナーに表示されるヒントを非表示にします | インターフェースとターミナル | Any file |
| [`spinnerTipsOverride`](#spinnertipsoverride) | スピナーのローテーションに独自のヒントを追加するか、組み込みのヒントを置き換えます | インターフェースとターミナル | Any file |
| [`spinnerVerbs`](#spinnerverbs) | ターンの実行中に表示される動詞を追加または置き換えます | インターフェースとターミナル | Any file |
| [`sshConfigs`](#sshconfigs) | Desktop の環境ドロップダウンに [SSH 接続](/docs/ja/desktop#pre-configure-ssh-connections-for-your-team)を追加します | リモート、デスクトップ、通知 | User or managed |
| [`sshHostAllowlist`](#sshhostallowlist) | [Desktop の SSH セッション](/docs/ja/desktop#restrict-which-ssh-hosts-users-can-connect-to)が到達できるホストを制限します | リモート、デスクトップ、通知 | Managed |
| [`statusLine`](#statusline) | 独自のコマンドを実行して、プロンプトの下に[ステータスライン](/docs/ja/statusline)を表示します | インターフェースとターミナル | Any file |
| [`strictKnownMarketplaces`](#strictknownmarketplaces) | ユーザーが追加およびインストール元として使用できる[マーケットプレイス](/docs/ja/plugins/overview)のソースの許可リストを指定します | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) | ユーザーおよびプロジェクトのソースからの[スキル](/docs/ja/skills)、[エージェント](/docs/ja/sub-agents)、[フック](/docs/ja/hooks)、[MCP サーバー](/docs/ja/mcp)をブロックします | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization.agents`](#strictpluginonlycustomization-agents) | [エージェント](/docs/ja/sub-agents)をプラグインと管理ソースに限定します | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization.hooks`](#strictpluginonlycustomization-hooks) | [フック](/docs/ja/hooks)をプラグインと管理ソースに限定します | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization.mcp`](#strictpluginonlycustomization-mcp) | [MCP サーバー](/docs/ja/mcp)をプラグインと管理ソースに限定します | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization.skills`](#strictpluginonlycustomization-skills) | [スキル](/docs/ja/skills)をプラグインと管理ソースに限定します | プラグインとスキル | Managed |
| [`subagentPromptCacheTtl`](#subagentpromptcachettl) | サブエージェントおよびメインの会話以外のリクエストについて、[プロンプトキャッシュの有効期間](/docs/ja/prompt-caching#cache-lifetime)を選択します | モデルと応答 | Any file |
| [`subagentStatusLine`](#subagentstatusline) | 独自のコマンドで、[サブエージェント](/docs/ja/sub-agents)のタスク表示の行を書き換えます | インターフェースとターミナル | Any file |
| [`switchModelsOnFlag`](#switchmodelsonflag) | [安全性分類器](/docs/ja/model-config#ask-before-switching)がリクエストを警告したときに、モデルを自動的に切り替えるか一時停止します | モデルと応答 | Any file |
| [`syncClaudeAiPlugins`](#syncclaudeaiplugins) | [claude.ai アカウントで有効になっているプラグイン](/docs/ja/plugins/loading#synced-plugins)の読み込みと、新しいプラグインのダウンロードを停止します | プラグインとスキル | User, local, or managed |
| [`syncClaudeAiSkills`](#syncclaudeaiskills) | [claude.ai アカウントで有効になっているスキル](/docs/ja/skills#how-synced-skills-behave)の読み込みと、新しいスキルのダウンロードを停止します | プラグインとスキル | User, local, or managed |
| [`syntaxHighlightingDisabled`](#syntaxhighlightingdisabled) | 差分とコードブロックのシンタックスハイライトをオフにします | インターフェースとターミナル | Any file |
| [`taskOutputMaxChars`](#taskoutputmaxchars) | v2.1.277 で、サイズ指定の対象だった `TaskOutput` ツールとともに削除されました | メモリとコンテキスト | Any file |
| [`teammateDefaultModel`](#teammatedefaultmodel) | v2.1.234 で削除されました。Claude Code がチームメイトのモデルを選択する方法については、[チームメイトとモデルを指定する](/docs/ja/agent-teams#specify-teammates-and-models)を参照してください | グローバル設定 | Global config |
| [`teammateMode`](#teammatemode) | [エージェントチームのチームメイトの表示方法](/docs/ja/agent-teams#choose-a-display-mode)を選択します | エージェント、セッション、worktree | Any file |
| [`terminalProgressBarEnabled`](#terminalprogressbarenabled) | 対応しているターミナルで、ターミナルのプログレスバーを非表示にします | インターフェースとターミナル | Any file |
| [`terminalTitleFromRename`](#terminaltitlefromrename) | [`/rename`](/docs/ja/sessions#name-your-sessions) と `--name` がターミナルのタブタイトルを変更しないようにします | インターフェースとターミナル | Any file |
| [`theme`](#theme) | 組み込みまたはカスタムのインターフェースの[カラーテーマ](/docs/ja/terminal-config#match-the-color-theme)を選択します | インターフェースとターミナル | Any file |
| [`timeFormat`](#timeformat) | インターフェース内の時刻を、12 時間制、24 時間制、UTC、または strftime パターンで表示します | インターフェースとターミナル | Any file |
| [`timeZone`](#timezone) | インターフェース内の時刻を、システムとは異なるタイムゾーンで表示します | インターフェースとターミナル | Any file |
| [`tui`](#tui) | [フルスクリーン](/docs/ja/fullscreen)またはクラシックのターミナルレンダラーを選択します | インターフェースとターミナル | Any file |
| [`ultracode`](#ultracode) | 指示がなくても、実質的なタスクごとに Claude に[ワークフロー](/docs/ja/workflows#let-claude-decide-with-ultracode)を計画させます | モデルと応答 | Any file |
| [`useAutoModeDuringPlan`](#useautomodeduringplan) | [plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)で [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)の分類器がシェルコマンドをレビューできるようにします。代わりにプロンプトを表示するには `false` を設定します | 権限設定 | User, local, or managed |
| [`verbose`](#verbose) | 切り詰められた要約ではなく[ツールの完全な出力](/docs/ja/cli-reference#cli-flags)を表示します。両方が設定されている場合は `viewMode` が優先されます | インターフェースとターミナル | Any file |
| [`viewMode`](#viewmode) | すべてのセッションを [default、verbose、または focus ビュー](/docs/ja/cli-reference#cli-flags)で開始します | インターフェースとターミナル | Any file |
| [`vimInsertModeRemaps`](#viminsertmoderemaps) | `jj` などの 2 キーの [INSERT モードのシーケンス](/docs/ja/interactive-mode#remap-insert-mode-key-sequences)を Escape に割り当てます | インターフェースとターミナル | User or managed |
| [`voice`](#voice) | [音声入力](/docs/ja/voice-dictation)をオンにし、長押しモードまたはタップモードを選択します | インターフェースとターミナル | Any file |
| [`voiceEnabled`](#voiceenabled) | 旧来の単一キー形式で[音声入力](/docs/ja/voice-dictation)をオンにします | インターフェースとターミナル | Any file |
| [`wheelScrollAccelerationEnabled`](#wheelscrollaccelerationenabled) | フルスクリーンレンダリングで[マウスホイールの加速](/docs/ja/fullscreen#mouse-wheel-scrolling)をオフにします | インターフェースとターミナル | Any file |
| [`workflowKeywordTriggerEnabled`](#workflowkeywordtriggerenabled) | プロンプト内の `ultracode` という語で[ワークフロー](/docs/ja/workflows)を開始できるようにします。ワークフローを開始せずにこの語を入力するには `false` を設定します | フックと自動化 | Any file |
| [`workflowSizeGuideline`](#workflowsizeguideline) | [動的ワークフロー](/docs/ja/workflows)で Claude が目標とするエージェント数を設定します | フックと自動化 | Any file |
| [`worktree`](#worktree) | Claude Code が git の [worktree](/docs/ja/worktrees) を作成する方法を設定します | エージェント、セッション、worktree | Any file |
| [`worktree.baseRef`](#worktree-baseref) | 新しい [worktree](/docs/ja/worktrees) を、リモートのデフォルトブランチまたはローカルの HEAD から分岐させます | エージェント、セッション、worktree | Any file |
| [`worktree.bgIsolation`](#worktree-bgisolation) | バックグラウンドセッションが [worktree](/docs/ja/worktrees) を使わずに作業コピーを編集できるようにします | エージェント、セッション、worktree | Any file |
| [`worktree.sparsePaths`](#worktree-sparsepaths) | 各 [worktree](/docs/ja/worktrees) で必要なディレクトリのみをチェックアウトします | エージェント、セッション、worktree | Any file |
| [`worktree.symlinkDirectories`](#worktree-symlinkdirectories) | 大きなディレクトリを複製する代わりに、各 [worktree](/docs/ja/worktrees) にシンボリックリンクします | エージェント、セッション、worktree | Any file |
| [`wslInheritsWindowsSettings`](#wslinheritswindowssettings) | WSL が Windows のポリシーチェーンから[管理設定](/docs/ja/managed-settings)を読み取るようにします | エンタープライズと管理設定 | Managed |

<h2 id="model-and-responses">
  モデルと応答
</h2>

Claude Code が使用するモデルと応答方法を選択します。これらの設定が `/model` コマンドと環境変数とどのように相互作用するかについては、[モデル設定](/docs/ja/model-config)を参照してください。

<h3 id="advisormodel">
  `advisorModel`
</h3>

Claude がサーバー側の[アドバイザーツール](/docs/ja/advisor)を呼び出すときに回答するモデルを選択します。これを設定解除するとアドバイザーがオフになります。アドバイザーはメインモデル以上の能力を持つ必要があります。受け入れられるペアリングと受け入れられないペアリングを選択した場合の動作については、[アドバイザーモデルを選択](/docs/ja/advisor#choose-an-advisor-model)を参照してください。

通常、このキーを手動で編集することはありません。`/advisor` を実行して、現在の選択、アドバイザーができるモデル、および**アドバイザーなし**を表示するピッカーを開きます。Claude Code は選択を `~/.claude/settings.json` のこのキーに保存します。[リモートコントロール](/docs/ja/remote-control)クライアントから、またはリモートワーカーに接続されたセッションで選択した場合、その選択はそのセッションのみに適用され、このキーは変更されません。

アカウントが[使用クレジット同意](/docs/ja/advisor#fable-advisor-and-usage-credits)を必要とする場合は、`/model fable` を実行して最初に同意を受け入れます。これを行うまで、`/advisor` で Fable を選択しても何も保存されず、Claude Code は最初に `/model fable` を実行するよう指示します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、エイリアス `"fable"`、`"opus"`、または `"sonnet"` のいずれか。これらは Claude Code の現在のデフォルトバージョンのそのモデルファミリーに解決されます。または、`"claude-opus-5-5"` などの完全なモデル ID
* **デフォルト**: 設定解除されているため、アドバイザーはオフです
* **セッションごとのオーバーライド**: `--advisor` はこのキーより優先されます。[`CLAUDE_CODE_DISABLE_ADVISOR_TOOL`](/docs/ja/env-vars)はアドバイザーをオフにし、このキーはそれをオンに戻すことはできません

```json settings.json theme={null}
{
  "advisorModel": "opus"
}
```

このキーは、Amazon Bedrock や Claude Platform on AWS など、アドバイザーが[利用できない](/docs/ja/advisor#requirements)プロバイダーには影響しません。`"fable"` には[Fable アクセス](/docs/ja/advisor#choose-an-advisor-model)が必要です。

<h3 id="alwaysthinkingenabled">
  `alwaysThinkingEnabled`
</h3>

このキーを `false` に設定して、すべてのセッションで[拡張思考](/docs/ja/model-config#extended-thinking)をオフにします。思考はデフォルトでオンなので、`true` は何も変わりません。ほとんどの人はファイルを編集するのではなく `/config` を通じてこれを設定します。

Opus 5.5、Sonnet 5.5、Haiku 5.5、Fable モデルなど、常に思考するモデルでは、`false` は効果がありません。[サードパーティプロバイダー](/docs/ja/third-party-integrations)では、Claude Code は思考をオフにする代わりに `thinking` パラメータを省略するため、適応推論モデルは引き続き思考する可能性があります。Anthropic API で思考をオフにした場合、Claude Code は、Opus 5 など[その組み合わせを受け付けない](/docs/ja/errors#effort-isnt-available-with-thinking-turned-off)ことが分かっているモデルに対して、より高いレベルの代わりに effort `high` を送信します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: 効果なし。思考は既にオンです
  * `false`: Claude Code はすべてのセッションで拡張思考をオフにします
* **デフォルト**: 設定解除されているため、思考はそれをサポートするモデルではオンです
* **セッションごとのオーバーライド**: [`MAX_THINKING_TOKENS`](/docs/ja/env-vars)はこのキーより優先されます。`0` は `false` と同じモデルおよびプロバイダーの制限の下で思考をオフにし、正の値は、このキーが `false` の場合でも思考をオンにします。適応推論モデルでは、数値自体は無視されます

```json settings.json theme={null}
{
  "alwaysThinkingEnabled": false
}
```

<h3 id="availablemodels">
  `availableModels`
</h3>

メインセッション、[サブエージェント](/docs/ja/sub-agents)、[スキル](/docs/ja/skills)、および[アドバイザー](/docs/ja/advisor)で選択できるモデルを制限します。管理リストは `/model`、`--model`、および開発者自身のファイルの `model` キーを制限します。リスト外のモデルは選択できません。デフォルトのプレフィックスマッチングでは、これは Default オプション自体には影響しません。[`enforceAvailableModels`](#enforceavailablemodels)とペアにしてください。

* **スコープ**: [`任意のファイル`](#scopes)。組織に対して強制するために、管理設定にデプロイします。
* **タイプ**: モデルエイリアスまたは ID の配列
* **デフォルト**: 設定解除されているため、すべてのモデルが利用可能です

この例では、Sonnet と Haiku モデルのみを選択できます:

```json settings.json theme={null}
{
  "availableModels": ["sonnet", "haiku"]
}
```

`"claude-opus-5"` などのモデル ID エントリは、Opus 5.5 などそれを拡張する後のバージョンも許可します。これらのバージョンのいずれかをブロックするには、[`deniedModels`](#deniedmodels)を使用します。各モデル ID エントリが名前を付けたバージョンのみを許可するようにするには、[`availableModelsMatch`](#availablemodelsmatch)を使用します。[モデル選択を制限](/docs/ja/model-config#restrict-model-selection)を参照してください。

<h3 id="availablemodelsmatch">
  `availableModelsMatch`
</h3>

[`availableModels`](#availablemodels)エントリがモデル ID とどのように一致するかを選択します。デフォルトでは、モデル ID エントリはそれを拡張する後のバージョンも許可するため、`"claude-opus-5"` は Opus 5.5 を許可します。`"exact"` では、各モデル ID エントリは名前を付けたバージョンのみを許可するため、そのモデルの新しいバージョンはリストに追加されるまでブロックされたままです。Claude Code v2.1.283 以降が必要です。

* **スコープ**: [`管理`](#scopes)。Claude Code はユーザー、プロジェクト、ローカル設定および `--settings` のキーを無視し、警告を表示します
* **タイプ**: 文字列、以下のいずれか:
  * `"prefix"`: モデル ID エントリはそのバージョンと、別のセグメントで拡張するモデル ID を許可します
  * `"exact"`: モデル ID エントリは名前を付けたバージョンのみを許可します。日付付き ID を含むため、`"claude-opus-5"` は Opus 5 を許可しますが `claude-opus-5-5` は許可しません。`"opus"` などのファミリーエイリアスは依然としてファミリー全体を許可し、`best`、`opusplan`、および `default` エントリは無視されます
* **デフォルト**: `"prefix"`

この例は Opus 5 と Sonnet 5 を許可し、どちらの後のリリースも許可しません:

```json managed-settings.json theme={null}
{
  "availableModels": ["claude-opus-5", "claude-sonnet-5"],
  "availableModelsMatch": "exact"
}
```

`"exact"` では、リストが少なくとも 1 つのモデルまたはファミリーを名前付けするときはいつでも、Default オプションもリストされたモデルに制限されます。[特定のモデルまたはバージョンをブロック](/docs/ja/model-config#block-specific-models-or-versions)を参照してください。

<h3 id="deniedmodels">
  `deniedModels`
</h3>

[`availableModels`](#availablemodels)許可リストの有無にかかわらず、特定のモデルをブロックし、そのリストがそれらを許可する場合でもブロックします。Claude Code はブロックされたモデルを `/model` ピッカーから非表示にし、`availableModels` が強制される場所ではどこでもモデルを選択できません。Default オプションのセッションは、[特定のモデルまたはバージョンをブロック](/docs/ja/model-config#block-specific-models-or-versions)で説明されているように、ブロックされたモデルも実行しません。Claude Code v2.1.283 以降が必要です。

* **スコープ**: [`管理`](#scopes)。Claude Code はユーザー、プロジェクト、ローカル設定および `--settings` のキーを無視し、警告を表示します
* **タイプ**: モデルエイリアスまたは ID の配列
  * `"opus"` などのファミリーエイリアスはそのファミリーのすべてのモデルをブロックします
  * `"claude-opus-5-5"` などのモデル ID は、日付付きおよびプロバイダー固有の ID を含むすべてのスペルでそのバージョンをブロックします
  * `"claude-opus-5"` などのマイナーバージョンなしのモデル ID は、Opus 5.5 などの後のマイナーバージョンもブロックします。Opus 5 のみをブロックするには `"claude-opus-5-0"` を記述します
  * `best`、`opusplan`、および `default` エントリは無視されます
* **デフォルト**: 設定解除されているため、モデルはブロックされません

この例は Opus と Sonnet モデルを許可し、Opus 5.5 をブロックします:

```json managed-settings.json theme={null}
{
  "availableModels": ["opus", "sonnet"],
  "deniedModels": ["claude-opus-5-5"]
}
```

[特定のモデルまたはバージョンをブロック](/docs/ja/model-config#block-specific-models-or-versions)を参照してください。

<h3 id="effortlevel">
  `effortLevel`
</h3>

保存していないモデルのデフォルト[努力レベル](/docs/ja/model-config#adjust-effort-level)を設定します。低いレベルは単純なタスクではより高速で安価であり、高いレベルは複雑な問題でより深く推論します。

マシン上のインタラクティブセッションで `/effort low`、`medium`、`high`、または `xhigh` を実行すると、Claude Code はレベルをファイルを編集するのではなく [`modelSettings`](#modelsettings)の下のアクティブなモデルに保存します。v2.1.251 より前では、`/effort` はこのキーを書き込みました。

同じ設定ファイル内で、Claude Code はこのキーではなくモデルの保存されたレベルを使用します。[`modelSettings`](#modelsettings)はクロスファイルの優先順位を述べています。

リモートワーカーに接続されたセッション、`-p` 実行、および Agent SDK では、`/effort` はそのセッションのみに適用されます。[努力レベルを調整](/docs/ja/model-config#adjust-effort-level)はそのセッションのみに適用されるインタラクティブな選択肢もリストします。`/effort` が出力するメッセージは、どちらが起こったかを示します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか:
  * `"low"`: 最小限の推論。短く、スコープが限定され、レイテンシに敏感で、インテリジェンスに敏感ではないタスク用
  * `"medium"`: コスト敏感な作業のトークン使用量を削減します。インテリジェンスをいくらか取引できます
  * `"high"`: トークン使用量とインテリジェンスのバランスを取ります
  * `"xhigh"`: より高いトークン支出でより深い推論
* **デフォルト**: 設定解除されています
* **セッションごとのオーバーライド**: `--effort` はこのキーより優先されます。[`CLAUDE_CODE_EFFORT_LEVEL`](/docs/ja/env-vars)は両方より優先されます

```json settings.json theme={null}
{
  "effortLevel": "xhigh"
}
```

ユーザー設定ファイル `~/.claude/settings.json` では、このキーは `/effort` が保存する前の古い形式です。モデルごとにレベルを保存し、以前に適用された場所に適用され続けます。Opus 5、Fable 5.1、および以前のモデルで。Opus 5.5 およびそれ以降にリリースされたモデルはそれを無視し、[`modelSettings`](#modelsettings)の下でレベルを保存するまで独自のデフォルトで開始します。これは `/effort` が書き込みます。プロジェクト、ローカル、管理設定、および `--settings` では、このキーはすべてのモデルに適用されます。

<h3 id="enforceavailablemodels">
  `enforceAvailableModels`
</h3>

`/model` ピッカーには**Default**オプションがあり、[`default` モデル設定](/docs/ja/model-config#default-model-setting)はそれが解決するモデルを説明します。[`availableModels`](#availablemodels)許可リストは名前を付けることができるモデルを制限しますが、デフォルト[プレフィックスマッチング](#availablemodelsmatch)では、アカウントタイプのデフォルトを再マップしないため、**Default**はリスト外のモデルに解決できます。このキーはそのギャップを閉じます。Claude Code v2.1.175 以降が必要です。

組織が管理設定をデプロイすると、Claude Code はこのキーを管理ソースからのみ読み取り、他のファイルでは無視します。

起動時のモデルチェックにこのキーがどのように適用されるかについては、[Amazon Bedrock](/docs/ja/amazon-bedrock#when-your-organization-enforces-a-model-allowlist) および [Google Cloud の Agent Platform](/docs/ja/google-vertex-ai#when-your-organization-enforces-a-model-allowlist) を参照してください。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: **Default**が `availableModels` 外のモデルに解決される場合、Claude Code はそれをリスト内の最初の利用可能なモデルに解決します
  * `false`: このキーは**Default**の解決方法を変更しません
* **デフォルト**: `false`

この例は、名前付き選択を Sonnet と Haiku モデルに制限し、**Default**を利用可能なそれらの最初のものに解決します:

```json settings.json theme={null}
{
  "availableModels": ["sonnet", "haiku"],
  "enforceAvailableModels": true
}
```

このキーは `availableModels` が設定解除されているか空の場合は効果がありません。[Default モデルの許可リストを強制](/docs/ja/model-config#enforce-the-allowlist-for-the-default-model)を参照してください。Claude Code v2.1.175 以降が必要です。

<h3 id="fallbackmodel">
  `fallbackModel`
</h3>

プライマリモデルがオーバーロードされているか利用できない場合に、Claude Code が順番に試すバックアップモデルに名前を付けます。Claude Code はターンの残りの間、チェーン内の次の利用可能なモデルに切り替え、通知を表示します。チェーンがない場合、Claude Code は同じモデルを再試行してからサーバーのエラーを表示し、再試行するか自分でモデルを切り替えます。

切り替えは、フォールバックモデルでコールド[プロンプトキャッシュ](/docs/ja/prompt-caching#switching-models)を使用した 1 ターンを意味します。次のメッセージはプライマリモデルを最初に再度試します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: モデルエイリアスまたは ID の配列。`"default"` はデフォルトモデルに展開されます
* **デフォルト**: 設定解除されているため、失敗したリクエストは別のモデルで再試行されません
* **セッションごとのオーバーライド**: `--fallback-model` はこのキーより優先されます

この例は、プライマリモデルが失敗したときに最初に Sonnet 5 を試し、次に Haiku 4.5 を試します:

```json settings.json theme={null}
{
  "fallbackModel": ["claude-sonnet-5", "claude-haiku-4-5"]
}
```

ほとんどの配列設定とは異なり、このキーは設定ファイル全体でマージされません。最も優先度の高いファイルがそれを定義すると、チェーン全体が供給されます。プロジェクトファイルが `["claude-sonnet-5"]` を設定し、ユーザーファイルが `["claude-haiku-4-5"]` を設定する場合、チェーンは `["claude-sonnet-5"]` のみです。Claude Code はリストから最大 3 つの異なる許可されたモデルを保持し、残りを無視します。[フォールバックモデルチェーン](/docs/ja/model-config#fallback-model-chains)を参照してください。

<h3 id="fastmode">
  `fastMode`
</h3>

利用可能なセッションで[高速モード](/docs/ja/fast-mode)をオンにします。高速反復やライブデバッグなどのインタラクティブな作業用で、トークンあたりのコストが高い速度が必要な場合。通常、このキーを手動で編集することはありません。`/fast` を実行すると `fastMode: true` が `~/.claude/settings.json` に書き込まれ、再度実行すると高速モードをオフにするキーが削除されます。高速モードは Opus 5.5、Opus 5、および Opus 4.8 でのみ実行されます。別のモデルからオンにするとあなたを Opus に切り替え、サポートされていないモデルに切り替えるとオフになります。[高速モードがオンの間にモデルを切り替え](/docs/ja/fast-mode#switch-models-while-fast-mode-is-on)を参照してください。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は利用可能なセッションで高速モードをオンにします
  * `false`: 高速モードはオフのままです
* **デフォルト**: 設定解除されているため、高速モードはオフです
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_DISABLE_FAST_MODE`](/docs/ja/env-vars)は 1 つのセッションで高速モードをオフにし、このキーはそれをオンに戻すことはできません

```json settings.json theme={null}
{
  "fastMode": true
}
```

<h3 id="fastmodepersessionoptin">
  `fastModePerSessionOptIn`
</h3>

通常、`/fast` を実行すると [`fastMode`](#fastmode)がユーザー設定に保存されるため、高速モードは後のすべてのセッションの開始時にオンになります。このキーを `true` に設定して、それを停止します。保存された `fastMode: true` はセッション開始時に高速モードをオンにしなくなり、各ユーザーは必要な各セッションで `/fast` を実行する必要があります。Claude Code は `fastMode` キーをファイルに残すため、このキーをオフにすると古い動作が復元されます。

Team または Enterprise プランのオーナーは、[サーバー管理設定](/docs/ja/server-managed-settings)を通じて組織全体にデプロイできます。管理設定がキーを設定すると、`/fast on` はインタラクティブターミナルセッション外で拒否され、組織が高速モードを無効にしたことを報告します。これは[非インタラクティブモード](/docs/ja/headless)、[VS Code 拡張機能](/docs/ja/vs-code)、および[クラウドセッション](/docs/ja/claude-code-on-the-web)をカバーします。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: 保存された `fastMode: true` はセッション開始時に高速モードをオンにしなくなるため、各ユーザーは必要な各セッションで `/fast` を実行します。`--settings` で渡された `fastMode: true` は、管理設定がこのキーを設定しない限り、そのセッションでもカウントされます
  * `false`: 保存された `fastMode: true` は後のすべてのセッションの開始時に高速モードをオンにします
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "fastModePerSessionOptIn": true
}
```

[セッションごとのオプトインを必須にする](/docs/ja/fast-mode#require-per-session-opt-in)を参照してください。

<h3 id="language">
  `language`
</h3>

Claude がデフォルトで英語以外の言語で応答するようにします。応答の固定リストはありません。Claude Code は値を Claude に逐語的に、常にその言語で応答するという指示として渡すため、Claude が読むことができる言語名は機能します。Claude Code は値をチェックしないため、スペルが間違った名前はエラーを生成するのではなく、書かれたとおりに Claude に到達します。同じ値は[音声ディクテーション](/docs/ja/voice-dictation#change-the-dictation-language)の言語を設定します。これは[サポートされているディクテーション言語](/docs/ja/voice-dictation#change-the-dictation-language)の固定リストを持ち、自動生成されたセッションタイトルも設定します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、`"japanese"`、`"spanish"`、`"french"` などの言語名。Claude Code はそれを検証しません
* **デフォルト**: 設定解除されています。セッションタイトルは会話の言語と一致します

```json settings.json theme={null}
{
  "language": "japanese"
}
```

<h3 id="maxeffortlevel">
  `maxEffortLevel`
</h3>

セッションが使用できる[努力レベル](/docs/ja/model-config#adjust-effort-level)をキャップし、低いレベルを利用可能なままにします。より高いレベルはキャップで実行されます。`/effort`、`/model` ピッカー、`--effort`、[`CLAUDE_CODE_EFFORT_LEVEL`](/docs/ja/env-vars)、スキルまたはサブエージェントの `effort` frontmatter、またはモデル自体のデフォルトから。Claude Code はリクエストの前にキャップ自体を適用するため、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry を含むすべてのプロバイダーで保持されます。Claude Code v2.1.267 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)。組織に対して強制するために、管理設定にデプロイします。複数のスコープがキャップを設定する場合、最も低いものが適用されるため、1 つのスコープで設定されたキャップを別のスコープから上げることはできません
* **タイプ**: 文字列、`"low"`、`"medium"`、`"high"`、`"xhigh"`、または `"max"` のいずれか。`"max"` 値はキャップを設定しません
* **デフォルト**: 設定解除されているため、キャップは適用されません
* **モデルごとのキャップ**: モデルの [`modelSettings`](#modelsettings)エントリに `maxEffortLevel` を追加します。そのエントリは、ユーザー設定や 1 つの[管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)など、両方を設定する設定ソース内でのみこのキーを置き換えます。そこで `"max"` を設定して、そのソースのキャップからモデルを除外します。Claude Code は他のソースからのキャップを依然として適用します

この例はすべてのモデルを `medium` でキャップし、Sonnet 4.6 を除外します:

```json settings.json theme={null}
{
  "maxEffortLevel": "medium",
  "modelSettings": {
    "claude-sonnet-4-6": {
      "maxEffortLevel": "max"
    }
  }
}
```

組織がモデルの[努力制限](/docs/ja/model-config#organization-effort-limits)も設定する場合、2 つのキャップの低い方が適用されます。

<h3 id="model">
  `model`
</h3>

すべての新しいセッションが使用するモデルを設定するため、毎回 `/model` で 1 つを選択する必要はありません。ここで設定してもセッション中に切り替えることは止まりません。管理者が[組織デフォルトモデル](/docs/ja/model-config#organization-default-model)を設定してユーザー選択をオーバーライドした場合、ユーザー、プロジェクト、またはローカル設定でこのキーを設定しても、そのモデルを取得します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、モデルエイリアスまたは完全なモデル ID
* **デフォルト**: 設定解除されているため、Claude Code はアカウントのデフォルトモデルを使用します
* **セッションごとのオーバーライド**: `--model` は [`ANTHROPIC_MODEL`](/docs/ja/env-vars)より優先され、両方は 1 つのセッションでこのキーより優先されます。管理 `model` を含む。[`availableModels`](#availablemodels)リストは依然として選択に適用されます

```json settings.json theme={null}
{
  "model": "claude-sonnet-5"
}
```

ここの値は [`ANTHROPIC_DEFAULT_MODEL`](/docs/ja/model-config#set-a-default-model-for-new-sessions)をランク付けし、Claude Code は他に何もモデルを選択しない場合にのみ使用します。

<h3 id="modeloverrides">
  `modelOverrides`
</h3>

Anthropic モデル ID をプロバイダー固有のモデル ID (Amazon Bedrock 推論プロファイル ARN など)にマップします。各モデルピッカーエントリは、プロバイダー API を呼び出すときにマップされた値を使用します。管理者は[Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry](/docs/ja/model-config#override-model-ids-per-version)でこれを使用して、各モデルバージョンを特定の推論プロファイル、バージョン名、またはガバナンス、コスト配分、または地域ルーティングのためのデプロイメントにルーティングします。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: モデル ID をプロバイダーモデル ID にマップするオブジェクト
* **デフォルト**: 設定解除されています

この例は、Opus 4.6 のすべての呼び出しを名前付き Bedrock 推論プロファイルにルーティングします:

```json settings.json theme={null}
{
  "modelOverrides": {
    "claude-opus-4-6": "arn:aws:bedrock:us-east-1:123456789012:inference-profile/example"
  }
}
```

[モデル ID をバージョンごとにオーバーライド](/docs/ja/model-config#override-model-ids-per-version)を参照してください。

<h3 id="modelpicker">
  `modelPicker`
</h3>

`/model` ピッカーが提供するモデルを、書き込む順序で、選択するラベルの下にリストします。ピッカーは組織が実行するモデルをリストします。組み込みラインアップの後または代わりに。各行の `model` は逐語的に取得されるため、`--model` が受け入れるもの、`opus` などのエイリアス、Anthropic モデル ID、または Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または LLM ゲートウェイのプロバイダー形式 ID を受け入れます。Claude Code v2.1.242 以降が必要です。

* **スコープ**: [`ユーザーまたは管理`](#scopes)。Claude Code は管理設定、`--settings`、およびユーザー設定からキーを読み取り、プロジェクトおよびローカル設定では無視するため、クローンするリポジトリはピッカーを再ラベルできません。これら 3 つの最も高いものがキーを設定すると、ラインアップ全体が供給され、Claude Code は 2 つのソースからラインアップをマージしません。
* **タイプ**: `options` 配列と行とオプションの `replaceBuiltInOptions` ブール値を持つオブジェクト
* **デフォルト**: 設定解除されているため、ピッカーは組み込みラインアップを表示します

この例は、組み込みラインアップの後に 2 つの Bedrock デプロイメントを追加し、チームが認識する名前の下に:

```json managed-settings.json theme={null}
{
  "modelPicker": {
    "options": [
      { "model": "us.anthropic.claude-opus-4-8", "label": "Opus (production)" },
      {
        "model": "us.anthropic.claude-sonnet-4-6",
        "label": "Sonnet (production)",
        "description": "Day-to-day work"
      }
    ]
  }
}
```

<span id="modelpicker-options" />

<span id="modelpicker-replacebuiltinoptions" />

<h4 id="fields-for-modelpicker">
  `modelPicker` のフィールド
</h4>

キーは 2 つのフィールドを取ります。1 つは行自体用で、もう 1 つは組み込みラインアップを置き換えるか追加するかです。

| フィールド | タイプ | 動作 |
| :- | :- | :- |
| `options` | 必須の `model` とオプションの `label`、`description`、および `behavesAs` を持つ行の配列 | ピッカーが表示する行。この順序で。グレーアウトされた行は下部に移動します。`label` がない場合、Claude Code は既知のモデルの組み込み名でタイトルを付けるか、モデル ID でタイトルを付けます。`description` がない場合は、一般的な 2 行目を書き込みます |
| `replaceBuiltInOptions` | ブール値、デフォルト `false` | これらの行のみ、**Default**、およびセッションが既に使用しているモデルの行を表示するには `true` に設定します。これらの行を組み込みラインアップの後に追加するには、設定解除のままにします |

`options` のエントリは、その `model` の横にオプションの `behavesAs` 文字列を持つこともできます。これには v2.1.257 以降が必要です。Claude Code バージョンが既に知っている `claude-opus-4-8` などのモデルの ID に設定します。`model` が バージョンより新しいエントリで。Claude Code はそれ以降、既知のモデルの機能と努力デフォルトをエントリに適用し、そのモデルを不明として扱いません。エントリのラベルと Claude Code がリクエストで送信するモデル ID は変わりません。

`replaceBuiltInOptions` がオンの場合、Claude Code はすべての他の行を非表示にします。組み込みラインアップ、[`availableModels`](#availablemodels)エントリ用に追加する行、[ゲートウェイディスカバリー](/docs/ja/llm-gateway-protocol#model-discovery)が見つけたモデル、および [`ANTHROPIC_CUSTOM_MODEL_OPTION`](/docs/ja/model-config#add-a-custom-model-option)。オフの場合、Claude Code は組み込みラインアップが既にカバーするリストされたモデルをスキップします。ラベルはピッカーが表示するものを変更し、Claude Code が実行するモデルではありません。

[`availableModels`](#availablemodels)許可リストはこれらの行に依然として適用されます。リストされたモデルを許可リストに追加する前に、[マージ動作](/docs/ja/model-config#merge-behavior)を読んでください。特定のモデル ID はそのファミリーのワイルドカード エントリを絞ります。Claude Code はピッカーを表示する前に各行をセッションに対してチェックします:

* **削除**: Claude Code が提供できない行。廃止されたモデルや組織がアクセスできないモデルなど
* **グレーアウト**: まだ選択できない行。理由を示して表示されます
* **行が生き残らない**: Claude Code は通常どおり許可リストでフィルタリングされた組み込みラインアップを保持します

Claude Code は解析できない行を削除し、残りを保持します。[壊れた設定ファイルを修正](/docs/ja/settings#fix-a-broken-settings-file)を参照してください。

<h3 id="modelpricing">
  `modelPricing`
</h3>

組織が支払うレートでリスト価格の代わりに支出を報告します。組織が契約レートを持っている場合に設定するため、開発者が見るドル数字は請求書と一致します。Claude Code は `/usage`、[ステータスライン](/docs/ja/statusline)、Agent SDK の `total_cost_usd`、[`--max-budget-usd`](/docs/ja/cli-reference)制限、および[OpenTelemetry](/docs/ja/monitoring-usage)コストメトリックとイベントのレートを適用します。レートを供給します。Claude Code は契約またはClaude Console から読み取りません。Claude Code v2.1.242 以降が必要です。

* **スコープ**: [`管理`](#scopes)。サーバー管理設定、MDM ポリシー、`managed-settings.json` ファイル、または[ポリシーヘルパー](/docs/ja/managed-settings#compute-the-policy-with-a-helper-program)を通じてキーをデプロイします。Claude Code はユーザー、プロジェクト、ローカル設定、`--settings`、および Windows のユーザー書き込み可能な[HKCU レジストリ](/docs/ja/managed-settings#where-each-mechanism-stores-the-policy)では無視します。サーバー管理設定では、各セッションはそのセッションの[設定フェッチ](/docs/ja/server-managed-settings#fetch-and-caching-behavior)が設定を確認するまでリスト価格でコストを報告します。Claude Code を埋め込み、[`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](/docs/ja/env-vars)を設定するホストアプリケーションは、SDK [`managedSettings`](/docs/ja/agent-sdk/typescript#options)オプションを通じて独自のテーブルを供給でき、Claude Code はマネージドソースがキーを設定しない場合にのみ使用し、Claude Code v2.1.246 以降でのみ使用します。
* **タイプ**: オプションの `multiplier` とオプションの `overrides` マップを持つオブジェクト
* **デフォルト**: 設定解除されているため、Claude Code はリスト価格を報告します。ホストアプリケーションがテーブルを供給しない限り

`multiplier` のみを設定して定額割引またはマークアップ、`overrides` のみをモデルごとのレート、または両方を設定します。

この例は Sonnet 4.6 の契約レートを設定し、すべての数字を 15% 削減します。Sonnet 行を含む:

```json managed-settings.json theme={null}
{
  "modelPricing": {
    "multiplier": 0.85,
    "overrides": {
      "claude-sonnet-4-6": {
        "input": 2.4,
        "output": 12,
        "cacheRead": 0.24,
        "cacheWrite": 3
      }
    }
  }
}
```

1 より上、最大 10 までマークアップするには `multiplier` を設定します。マークアップには Claude Code v2.1.271 以降が必要です。以前のバージョンは警告付きで 1 より上の `multiplier` を無視し、設定の残りを保持します。

手順を含む、レートが有効であることを確認する方法については、[契約レートで支出を報告](/docs/ja/costs#report-spend-at-your-contracted-rates)を参照してください。

<span id="modelpricing-multiplier" />

<span id="modelpricing-overrides" />

<h4 id="fields-for-modelpricing">
  `modelPricing` のフィールド
</h4>

| フィールド | タイプ | 動作 |
| :- | :- | :- |
| `multiplier` | 0 より大きく最大 10 の数値 | Claude Code が計算するすべてのコストをスケーリングします。`overrides` 行がカバーするかどうかに関わらず。1 未満は割引、1 より上はマークアップです |
| `overrides` | モデル ID をそれぞれ 0 から 10000 の `input`、`output`、`cacheRead`、および `cacheWrite` を持つレートオブジェクトにマップします | そのモデルの USD-per-million-token レート。すべて 4 つが必要です。`cacheWrite` は 5 分と 1 時間のキャッシュ書き込みの両方をカバーします。[どのモデルが行に適用されるか](#which-models-a-modelpricing-row-applies-to)を参照してください |

Claude Code はレートを書き込んだとおりに使用し、高速モード割増料金または[US のみの推論レート](https://platform.claude.com/docs/en/about-claude/pricing)を追加しません。`multiplier` も設定する場合、Claude Code はそれを行のレートの上に適用します。Claude Code は解析できないレートを持つ行、または解析できない `multiplier` を削除し、残りを保持します。[壊れた設定ファイルを修正](/docs/ja/settings#fix-a-broken-settings-file)を参照してください。

<h4 id="which-models-a-modelpricing-row-applies-to">
  どのモデルが `modelPricing` 行に適用されるか
</h4>

Claude Code は行のキーから行が適用されるモデルを決定します:

* **組み込みモデルの ID**: Claude Code 自体がモデルの独自の ID (例: `claude-sonnet-4-6`) またはその Bedrock、Agent Platform、または Foundry ID であるかどうかに関わらず、組み込みモデルに使用するキー。Claude Code はそのモデルのすべての日付スナップショット ID とプロバイダー固有の ID に行を適用します。
* **その他のキー**: 組み込みモデルの ID ではないキー。ゲートウェイモデルエイリアスなど。Claude Code はそのキーのみに行を適用します。モデル ID がキーの 1 つと正確に一致し、組み込みモデルの ID でキーされた行の下にも該当する場合、Claude Code は正確な一致を使用します。
* **Bedrock アプリケーション推論プロファイル**: Claude Code がプロファイルを [`modelOverrides`](#modeloverrides)マップまたは [`bedrock:GetInferenceProfile` ルックアップ](/docs/ja/amazon-bedrock#iam-configuration)を通じてルーティングするモデルに解決した後、Claude Code はそのモデルの行をプロファイルに適用します。

<h3 id="modelsettings">
  `modelSettings`
</h3>

使用する各モデルの[努力レベル](/docs/ja/model-config#adjust-effort-level)を保存します。Claude Code v2.1.251 以降が必要です。

マシン上のインタラクティブセッションで、`/effort` または `/model` ピッカーの努力スライダーで `low`、`medium`、`high`、または `xhigh` をデフォルトとして保存すると、Claude Code はそれを使用しているモデルの下にここにそのレベルを書き込むため、このキーを自分で編集することはめったにありません。[VS Code 拡張機能のモデルピッカー](/docs/ja/vs-code#use-the-prompt-box)でこれらのレベルのいずれかを選択すると、Claude Code は同じ方法でここに保存します。[`effortLevel`](#effortlevel)エントリは `/effort` がそのセッションのみに適用されるセッションをリストします。

レベルを変更または削除するには、キーを手動で編集します。

ここで指定するモデルの `effortLevel` は、同じ設定ファイルの最上位 [`effortLevel`](#effortlevel)より優先されます。ファイル間では、Claude Code は各モデルを個別に解決します。そのモデルの `effortLevel` または[そのモデルに適用される](#effortlevel)最上位 `effortLevel` のいずれかを設定する最も優先度の高い[設定ファイル](/docs/ja/settings#settings-precedence)が決定するため、管理設定の `effortLevel` はユーザー設定で保存されたレベルより優先されます。[努力レベルを調整](/docs/ja/model-config#adjust-effort-level)は、起動時の `--effort` など、保存されたレベルをオーバーライドできるその他のものをリストします。

1 つのモデルの努力レベルを設定するのではなくキャップするには、そのモデルのエントリに [`maxEffortLevel`](#maxeffortlevel)フィールドを追加します。フィールドには Claude Code v2.1.267 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: モデル名を、以下のいずれかのフィールドを持つオブジェクトにマッピングするオブジェクト:
  * `effortLevel`: `"low"`、`"medium"`、`"high"`、`"xhigh"` のいずれか
  * [`maxEffortLevel`](#maxeffortlevel): モデルが実行できる最も高い effort レベル
  * `autoCompactWindow`: `100000` から `1000000` までのトークン数、またはモデルに合わせて調整されたウィンドウを使う `"auto"`。[`/autocompact`](/docs/ja/model-config#set-the-auto-compact-window) はここに保存します。そのモデルについては、この値が同じ設定ファイル内の最上位の [`autoCompactWindow`](#autocompactwindow) より優先されます。Claude Code v2.1.288 以降が必要です
* **デフォルト**: 設定解除されています

Claude Code は各エントリを `claude-opus-5-5` などのモデルの正規名の下に書き込み、そのモデルのエイリアス、日付サフィックス、`[1m]`、および認識されたプロバイダー固有の ID を同じエントリと一致させます。

この例は Opus 5.5 を `high` に保ちながら、他のモデルは独自の保存またはデフォルトレベルを使用します:

```json settings.json theme={null}
{
  "modelSettings": {
    "claude-opus-5-5": {
      "effortLevel": "high"
    }
  }
}
```

`/effort auto` を実行して、使用しているモデルの保存されたレベルをクリアします。Claude Code は他のエントリと最上位の `effortLevel` をそのままにします。

<h3 id="outputstyle">
  `outputStyle`
</h3>

[出力スタイル](/docs/ja/output-styles)を名前で選択します。出力スタイルは、Claude の役割、トーン、出力形式を変更する保存された指示のセットです。組み込みの Explanatory および Learning スタイルや自分で書いたものなど。

セッション中にこのキーを変更すると、Claude は次のメッセージから新しいスタイルを使用します。そのメッセージがプロンプトキャッシュでコストするものについては、[出力スタイルを変更](/docs/ja/prompt-caching#changing-output-style)を参照してください。v2.1.251 より前では、編集は `/clear` を実行した後またはセッションを開始した後にのみ適用されました。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列。[組み込み](/docs/ja/output-styles#built-in-output-styles)または[カスタム](/docs/ja/output-styles#create-a-custom-output-style)出力スタイルの名前
* **デフォルト**: 設定解除されているため、Claude Code はデフォルトスタイルを使用します

この例は、タスク間に教育的な洞察を追加する組み込みの Explanatory スタイルを選択します:

```json settings.json theme={null}
{
  "outputStyle": "Explanatory"
}
```

<h3 id="promptcachettl">
  `promptCacheTtl`
</h3>

[プロンプトキャッシュ](/docs/ja/prompt-caching)がメイン会話を保持する期間を選択します。このキーはインタラクティブ、`-p`、および Agent SDK ターンに適用されます。Claude Code がインラインで実行するヘルパーと一緒に。1 時間のライフタイムはより長い休憩全体でキャッシュを温かく保ち、API は[各キャッシュ書き込みを 5 分のライフタイムより高いレートで請求します](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing)。Claude Code v2.1.242 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか:
  * `"5m"`: キャッシュは 5 分間保持されます
  * `"1h"`: キャッシュは 1 時間保持されます
* **デフォルト**: 設定解除されているため、各メイン会話リクエストは[そのデフォルトライフタイム](/docs/ja/prompt-caching#which-ttl-each-request-gets)を取得します
* **セッションごとのオーバーライド**: [`FORCE_PROMPT_CACHING_5M`](/docs/ja/env-vars)はすべてを優先し、次に [`CLAUDE_CODE_PROMPT_CACHE_TTL`](/docs/ja/env-vars)、次にこのキー、最後に [`ENABLE_PROMPT_CACHING_1H`](/docs/ja/env-vars)

この例はメイン会話を 1 時間のライフタイムに保ち、サブエージェントを 5 分のままにします:

```json settings.json theme={null}
{
  "promptCacheTtl": "1h",
  "subagentPromptCacheTtl": "5m"
}
```

各ライフタイムのコストについては、[キャッシュライフタイム](/docs/ja/prompt-caching#cache-lifetime)を参照してください。

<h3 id="showthinkingsummaries">
  `showThinkingSummaries`
</h3>

インタラクティブセッションで Claude の[拡張思考](/docs/ja/model-config#extended-thinking)の概要を参照してください。`Ctrl+O` で思考を展開するときに完全な概要が必要な場合に設定します。設定解除または `false` の場合、Anthropic API は思考ブロックを編集し、Claude Code は折りたたまれたスタブを表示します。サードパーティプロバイダーは編集しません。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: `Ctrl+O` で思考を展開するときに完全な思考概要が表示されます
  * `false`: Anthropic API は思考ブロックを編集し、Claude Code は折りたたまれたスタブを表示します
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "showThinkingSummaries": true
}
```

編集は、モデルが生成するものではなく、表示するものだけを変更します。思考支出を削減するには、代わりに[予算を低下させるか思考を無効にします](/docs/ja/model-config#extended-thinking)。

<h3 id="subagentpromptcachettl">
  `subagentPromptCacheTtl`
</h3>

[プロンプトキャッシュ](/docs/ja/prompt-caching)がメイン会話外で Claude Code が行うリクエストを保持する期間を選択します。このキーは[サブエージェント](/docs/ja/sub-agents)、[ワークフロー](/docs/ja/workflows)、および Claude Code 独自のバックグラウンドおよびヘルパーリクエスト (圧縮やセッションタイトルなど)に適用されます。1 時間のライフタイムはより長い休憩全体でキャッシュを温かく保ち、API は[各キャッシュ書き込みを 5 分のライフタイムより高いレートで請求します](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing)。Claude Code v2.1.242 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか:
  * `"5m"`: キャッシュは 5 分間保持されます
  * `"1h"`: キャッシュは 1 時間保持されます
* **デフォルト**: 設定解除されているため、これらの各リクエストは[そのデフォルトライフタイム](/docs/ja/prompt-caching#which-ttl-each-request-gets)を取得します
* **セッションごとのオーバーライド**: [`FORCE_PROMPT_CACHING_5M`](/docs/ja/env-vars)はすべてを優先し、次に [`CLAUDE_CODE_SUBAGENT_PROMPT_CACHE_TTL`](/docs/ja/env-vars)、次にこのキー、次に [`ENABLE_PROMPT_CACHING_1H`](/docs/ja/env-vars)。サブエージェント独自の frontmatter 値がランク付けされる場所については、[TTL を自分で選択](/docs/ja/prompt-caching#choose-the-ttl-yourself)を参照してください

この例はサブエージェントとメイン会話外の他のリクエストに 1 時間のライフタイムを与えます:

```json settings.json theme={null}
{
  "subagentPromptCacheTtl": "1h"
}
```

このキーは [`promptCacheTtl`](#promptcachettl)がカバーしないリクエストをカバーするため、Claude Code が行うすべてのリクエストのライフタイムを選択するには両方を設定します。サブエージェントのキャッシュがメイン会話のキャッシュとどのように異なるかについては、[サブエージェントとキャッシュ](/docs/ja/prompt-caching#subagents-and-the-cache)を参照してください。

<h3 id="switchmodelsonflag">
  `switchModelsOnFlag`
</h3>

[安全分類器がリクエストにフラグを立てた](/docs/ja/model-config#automatic-model-fallback)場合に何が起こるかを選択します。フォールバックモデルに切り替えて続行するか、切り替えるかプロンプトを編集するかを選択できるように一時停止します。

* **スコープ**: [`任意のファイル`](#scopes)。`/config` には **メッセージが警告対象となったときにモデルを切り替える** として表示され、選択肢は **自動的に切り替える** と **毎回確認する** です。
* **タイプ**: ブール値
  * `true`: Claude Code はフォールバックモデルに切り替えて続行します
  * `false`: インタラクティブセッションで Claude Code は一時停止して、切り替えるかプロンプトを編集するかを選択できます。ダイアログが表示できない場所 (`-p` 実行など)では、フラグされたリクエストはエラーで終了します
* **デフォルト**: 設定解除されています。Claude Code は自動的に切り替えますが、対話セッションでは[先に確認する](/docs/ja/model-config#ask-before-switching)場合があります

```json settings.json theme={null}
{
  "switchModelsOnFlag": false
}
```

[切り替える前に確認](/docs/ja/model-config#ask-before-switching)を参照してください。

<h3 id="ultracode">
  `ultracode`
</h3>

セッションを[ultracode](/docs/ja/workflows#let-claude-decide-with-ultracode)でオンで開始します。オンの場合、Claude は、あなたが尋ねるのを待つのではなく、各実質的なタスクのワークフローを計画します。Claude は[動的ワークフロー](/docs/ja/workflows)が有効になっており、モデルが `xhigh` 努力をサポートする場合にのみワークフローを計画します。キーはセッションの努力レベルを変更しません。ultracode はセッションが使用するレベルで実行されます。Claude Code はこのキーを読み取りますが、決して書き込みません。`/effort ultracode` は現在のセッションのみで ultracode をオンにします。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: 動的ワークフローが有効になっており、モデルが `xhigh` をサポートする場合、セッションは ultracode でオンで開始されます
  * `false`: セッションは ultracode でオフで開始されます
* **デフォルト**: 設定解除されているため、ultracode はオフです
* **セッションごとのオーバーライド**: `/effort ultracode` はこのキーなしで 1 つのセッションで ultracode をオンにし、`/effort ultracode off` はこのキーが `true` の場合、1 つのセッションでそれをオフにします。`--effort ultracode` フラグも 1 つのセッションでそれをオンにし、`xhigh` 努力で、Claude Code v2.1.203 以降が必要です

```json settings.json theme={null}
{
  "ultracode": true
}
```

セッションの努力レベルは [`effortLevel`](#effortlevel)、[`modelSettings`](#modelsettings)、および他の[努力ソース](/docs/ja/model-config#adjust-effort-level)から来ます。[`maxEffortLevel`](#maxeffortlevel)などの[努力キャップ](/docs/ja/model-config#organization-effort-limits)はそのレベルを低下させますが、ultracode をオフにしません。これと `/effort ultracode off` フォームには Claude Code v2.1.284 以降が必要です。v2.1.284 より前では、`ultracode: true` はセッションを `xhigh` 努力で実行し、`xhigh` より下の努力キャップは ultracode をオフに保ちました。Agent SDK `apply_flag_settings` コントロールリクエストもキーを受け入れます。

<h2 id="permission-settings">
  権限設定
</h2>

Claude が何を確認なしで実行できるか、セッションがどの権限モードで開始するか、auto モードの分類器が何を許可するかを決定します。ルール構文と権限モデルについては、[権限を設定する](/docs/ja/permissions)を参照してください。

<h3 id="allowmanagedpermissionrulesonly">
  `allowManagedPermissionRulesOnly`
</h3>

管理設定を権限ルールの唯一の設定ソースにします。Claude Code はユーザー、プロジェクト、ローカル、および `--settings` ファイル内の `allow`、`ask`、`deny` ルールを無視し、`--allowedTools` を無視し、権限プロンプトで常に許可する選択肢を非表示にし、新しいルールの保存を停止します。

[埋め込みホストからの親設定](/docs/ja/managed-settings#let-an-embedding-host-add-policy)が適用される場合、Claude Code はそれらを管理層の一部として扱います。それらの `allow` ルールと `additionalDirectories` を削除し、`deny` および `ask` ルールは保持します。ただし、パターンが `!` で始まる `Read` および `Edit` ルールは除きます。このキーを設定しているかどうかに関わらず、ホストは `!` ルールで管理ルールからパスを除外することはできません。

`--disallowedTools` ルールと現在のセッションの `deny` および `ask` ルールは、Claude Code が設定をセッション中に再度読み込んだ後を含めて、引き続き適用されます。これらは制限のみを行うため、管理ルールが付与するものを拡大することはできません。v2.1.257 より前では、Claude Code は最初の設定再度読み込み時にそれらのコマンドラインおよびセッションルールを削除していました。

`--disallowedTools` またはセッションルール内の `!` パターンが除外できるものについては、[Read および Edit ルール](/docs/ja/permissions#read-and-edit)を参照してください。

このキーを設定すると、Claude Code v2.1.282 以降では、次のソースにあるスキルおよび `.claude/commands/` ファイルの [`allowed-tools`](/docs/ja/skills#pre-approve-tools-for-a-skill) フロントマターも無視されます。

* リポジトリの `.claude/` ディレクトリ
* `~/.claude/skills/` および `~/.claude/commands/` ディレクトリ（[claude.ai から同期されたスキル](/docs/ja/skills#where-synced-skills-load)を含む）
* `--add-dir` ディレクトリ
* `~/.claude/skills/` またはプロジェクトの `.claude/skills/` 内で [`.claude-plugin` マニフェストにより宣言されたプラグイン](/docs/ja/plugins/loading#plugins-shared-through-a-repository)

管理設定からのスキルとバンドルスキルは `allowed-tools` を保持します。スキルの `disallowed-tools` は引き続き適用されます。Claude Code がこのフィールドを無視したときに開発者に何が表示されるかについては、[管理権限ルールのみが適用される場合](/docs/ja/skills#when-only-managed-permission-rules-apply)を参照してください。

* **スコープ**: [`Managed`](#scopes)
* **タイプ**: ブール値
  * `true`: 管理設定が権限ルールの唯一の設定ソースになります
  * `false`: Claude Code は管理ルールに加えて、ユーザー、プロジェクト、ローカル、および `--settings` ファイルから権限ルールを適用します
* **デフォルト**: 未設定。Claude Code はユーザー、プロジェクト、ローカル設定、および `--settings` から権限ルールを管理ルールに加えて適用します

```json managed-settings.json theme={null}
{
  "allowManagedPermissionRulesOnly": true
}
```

このキーは MCP サーバーの許可リストをロックダウンしません。そのためには、[`allowManagedMcpServersOnly`](#allowmanagedmcpserversonly)を設定してください。[管理のみの設定](/docs/ja/managed-settings#managed-only-settings)を参照してください。

<h3 id="automode">
  `autoMode`
</h3>

[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)の分類器がブロックおよび許可するものに独自のルールを追加します。これを使用して、分類器に組織が信頼するリポジトリ、バケット、ドメインを伝え、日常的な内部操作のブロックを停止させます。分類器には[組み込みの許可および拒否ルール](/docs/ja/auto-mode-config#inspect-the-defaults-and-your-effective-config)が付属しています。リテラル文字列 `"$defaults"` を配列に含めて、それらの組み込みルールをその位置に保持し、その周りに独自のルールを追加します。省略すると、それらを独自のルールに置き換えます。

* **スコープ**: [`User or managed`](#scopes)
* **タイプ**: `environment`、`allow`、`soft_deny`、`hard_deny` の散文ルール配列、および [`classifyAllShell`](#automode-classifyallshell) ブール値を含むオブジェクト
* **デフォルト**: 未設定。分類器は[組み込みルール](/docs/ja/auto-mode-config#inspect-the-defaults-and-your-effective-config)のみを使用します

この例は、`"$defaults"` を通じて組み込みの `soft_deny` ルールを保持し、`terraform apply` をブロックするルールを 1 つ追加します。

```json settings.json theme={null}
{
  "autoMode": {
    "soft_deny": ["$defaults", "Never run terraform apply"]
  }
}
```

これらのファイルの複数が同じ配列を設定する場合、Claude Code はエントリを連結します。ルール形式と各配列の適用方法については、[auto モードを設定する](/docs/ja/auto-mode-config)を参照してください。

<h3 id="automode-classifyallshell">
  `autoMode.classifyAllShell`
</h3>

auto モードがアクティブな間、すべての Bash および PowerShell コマンドを auto モードの分類器に通します。デフォルトでは、auto モードは任意のコードを実行できる許可ルールのみを一時停止します。具体的には、`Bash(*)` などのツール全体およびワイルドカードのルールと、`Bash(python *)` などのインタープリタまたはシェルラッパーのプレフィックスです。`Bash(npm test)` など、それ以外の許可ルールに一致するコマンドは、[コマンドごとの許可ドメイン](/docs/ja/sandboxing#per-command-allowed-domains-in-auto-mode)を持たない限り分類器をスキップします。スキップした場合、ルールのプレフィックスが想定していなかった破壊的な引数が見過ごされたまま通過する可能性があります。このキーを設定すると、セッションのすべてのシェル許可ルールが一時停止され、分類器がすべてのコマンドを確認します。Claude Code v2.1.193 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。[`autoMode`](#automode)が読み取られる場所で読み取られます。
* **タイプ**: ブール値
  * `true`: auto モードがアクティブな間、Claude Code はすべての Bash および PowerShell コマンドを分類器に通し、シェル許可ルールを一時停止します。auto モード外では、ルールは引き続き適用されます
  * `false`: auto モードは `Bash(*)` や `Bash(python *)` など、任意のコードを実行できる許可ルールのみを一時停止します。それ以外の許可ルールに一致するコマンドは、[コマンドごとの許可ドメイン](/docs/ja/sandboxing#per-command-allowed-domains-in-auto-mode)を持たない限り分類器をスキップし、その他すべてのシェルコマンドは分類器を通ります
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "autoMode": {
    "classifyAllShell": true
  }
}
```

[すべてのシェルコマンドを分類器にルーティングする](/docs/ja/auto-mode-config#route-all-shell-commands-through-the-classifier)を参照してください。

<h3 id="disableautomode">
  `disableAutoMode`
</h3>

[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)を `Shift+Tab` サイクルから削除します。`--permission-mode auto`、設定ファイル、または組み込みデフォルトから[auto モードで開始](/docs/ja/permission-modes#which-mode-a-session-starts-in)する可能性があるセッションは、代わりに `default` で開始します。管理者は管理設定で設定して、組織内の開発者が auto モードを使用するのを防ぎます。

* **スコープ**: [`Any file`](#scopes)。[管理設定](/docs/ja/managed-settings)で最も有用です。ユーザーはそれを上書きできません。`permissions` の下で `permissions.disableAutoMode` としても受け入れられます。
* **タイプ**: 文字列 `"disable"`
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "disableAutoMode": "disable"
}
```

<h3 id="permissions">
  `permissions`
</h3>

Claude が確認なしで使用できるツール、常にプロンプトを表示するツール、ブロックされるツールを制御し、セッションが開始する[権限モード](/docs/ja/permission-modes)を設定します。以下のすべての `permissions.*` キーはこのオブジェクトの下にネストされます。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: `allow`、`ask`、`deny`、`additionalDirectories`、`blockReadsOutsideWorkingDirectories`、`defaultMode`、`disableBypassPermissionsMode`、`disableAutoMode` を含むオブジェクト
* **デフォルト**: 未設定

この例は `npm run` コマンドを確認なしで承認し、`git push` の前にプロンプトを表示し、`.env` の読み取りをブロックし、セッションを `acceptEdits` で開始します。

```json settings.json theme={null}
{
  "permissions": {
    "allow": ["Bash(npm run *)"],
    "ask": ["Bash(git push *)"],
    "deny": ["Read(./.env)"],
    "defaultMode": "acceptEdits"
  }
}
```

3 つのルール配列は 1 つの構文を共有します。`permissions.allow` の下の[権限ルール構文](#permission-rule-syntax)を参照してください。異なるファイルからの権限ルールがどのように結合されるかについては、[スコープ全体での権限ルールのマージ方法](/docs/ja/permissions#settings-precedence)を参照してください。一般的に設定キーがどのように結合されるかについては、設定ガイドの[設定の優先順位](/docs/ja/settings#settings-precedence)を参照してください。

<h3 id="useautomodeduringplan">
  `useAutoModeDuringPlan`
</h3>

Claude Code が plan モード中にシェルコマンドを確認するために auto モードの分類器を使用するかどうかを選択します。デフォルトの `true` では、auto モードが利用可能な場合、分類器は計画中に各コマンドを確認し、プロンプトは表示されません。ただし、[重要パスの削除](/docs/ja/permission-modes#critical-paths)を除きます。`false` に設定すると、組み込みの読み取り専用セット外のすべてのコマンドに対して権限プロンプトが表示されます。`/config` に**プラン中に auto モードを使用**として表示されます。

* **スコープ**: [`User, local, or managed`](#scopes)。リポジトリがこれをオフにすることはできません。
* **タイプ**: ブール値
  * `true`: 未設定と同じです。auto モードが利用可能な場合、分類器は計画中に各シェルコマンドを確認し、プロンプトを表示しません。ただし、[重要パスの削除](/docs/ja/permission-modes#critical-paths)を除きます。これらのファイルのいずれかで `false` が設定されていれば、引き続きオフになります
  * `false`: 組み込みの読み取り専用セット外のすべてのコマンドに対して権限プロンプトが表示されます
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "useAutoModeDuringPlan": false
}
```

<h3 id="permissions-allow">
  `permissions.allow`
</h3>

Claude Code が確認なしで承認するツール使用をリストします。MCP ルールでは、`*` はツール名内の `mcp__<server>__` プレフィックスの後にのみ使用できます（例：`mcp__github__get_*`）。サーバー名には使用できません。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 権限ルール文字列の配列
* **デフォルト**: 未設定
* **セッションごとの上書き**: `--allowedTools` は 1 つのセッションに許可ルールを追加しますが、任意の設定ファイルからの拒否ルールは、それが指定するツールを引き続きブロックします

この例は `git diff` を承認し、Claude Code が確認なしに `.zshrc` を読み取ることを許可します。

```json settings.json theme={null}
{
  "permissions": {
    "allow": ["Bash(git diff *)", "Read(~/.zshrc)"]
  }
}
```

Claude Code はプロジェクトの `.claude/settings.json` から `allow` ルールを適用するのは、そのフォルダの[ワークスペース信頼ダイアログ](/docs/ja/permissions#project-allow-rules-and-workspace-trust)を受け入れた後のみです。

<h4 id="permission-rule-syntax">
  権限ルール構文
</h4>

権限ルールは `Tool` または `Tool(specifier)` の形式に従います。Claude Code は `deny` ルールを最初に評価し、次に `ask`、次に `allow` を評価し、各ルールの具体性に関係なく最初に一致したものが結果を決定します。[権限ルール評価順序](/docs/ja/permissions#manage-permissions)を参照してください。

各行は 1 つのルール形状とそれが一致するものを示します。

| ルール | 一致するもの |
| :- | :- |
| `Bash` | すべての Bash コマンド |
| `Bash(npm run *)` | `npm run` で始まるコマンド |
| `Read(./.env)` | `.env` ファイルの読み取り |
| `WebFetch(domain:example.com)` | example.com へのフェッチリクエスト |

ワイルドカード動作、Read、Edit、WebFetch、MCP、Agent ルールのツール固有パターン、および Bash パターンのセキュリティ制限を含む完全なルール構文については、[権限ルール構文](/docs/ja/permissions#permission-rule-syntax)を参照してください。

<h3 id="permissions-ask">
  `permissions.ask`
</h3>

`acceptEdits` や `bypassPermissions` など、本来であれば承認される権限モードであっても確認を求めるツール使用をリストします。`dontAsk` モードでは、Claude Code は一致するツール使用に対してプロンプトを表示する代わりに拒否します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 権限ルール文字列の配列
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "permissions": {
    "ask": ["Bash(git push *)"]
  }
}
```

<span id="exclude-sensitive-files" />

<h3 id="permissions-deny">
  `permissions.deny`
</h3>

Claude Code がブロックするツール使用をリストします。API キー、シークレット、または環境値を保持するファイルに使用します。Claude Code は一致するファイルをファイル検出と検索結果から除外し、それらの読み取りを拒否し、一致するパスの[Edit および Write ツール](/docs/ja/permissions#read-and-edit)をブロックします。

Read および Edit 拒否ルールは Claude の組み込みファイルツール、Claude Code が Bash で認識するファイルコマンド（`cat`、`head`、`tail`、`sed`、`tee` など）、および `> file` や `< file` などの Bash [リダイレクション](/docs/ja/permissions#redirections)のターゲットに適用されます。ファイル名を指定せずにファイルを読み取るコマンド（`grep -r pattern .` など）や任意のサブプロセスには適用されないため、OS レベルで強制するには[サンドボックスを有効にして](/docs/ja/sandboxing)ください。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 権限ルール文字列の配列
* **デフォルト**: 未設定
* **セッションごとの上書き**: `--disallowedTools` はこのキーと並行して 1 つのセッションに拒否ルールを追加します

この例は `.env` ファイル、`secrets` ディレクトリ、認証情報ファイルの読み取りを拒否し、`curl` コマンドをブロックします。

```json settings.json theme={null}
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(./config/credentials.json)",
      "Bash(curl *)"
    ]
  }
}
```

ツール名はグロブパターンを受け入れるため、`"*"` はすべてのツールを拒否し、`"mcp__*"` はすべての MCP ツールを拒否します。Claude Code は、他のツールがまだ Claude で利用可能である限り、[`EndConversation`](/docs/ja/tools-reference#endconversation-tool-behavior)ツールの拒否ルールを無視します。`Bash` 拒否ルールは Claude が書いたコマンドと一致するため、`Bash(curl *)` は `/usr/bin/curl` や `sh -c 'curl …'` を停止しません。[Bash ルールが一致しないもの](/docs/ja/permissions#bash-rule-limits)を参照してください。このキーは非推奨の `ignorePatterns` 設定に置き換わるものです。

<h3 id="permissions-additionaldirectories">
  `permissions.additionalDirectories`
</h3>

Claude に開始したディレクトリ外のディレクトリへのファイルアクセスを付与し、追加の[作業ディレクトリ](/docs/ja/permissions#working-directories)として使用します。ほとんどの `.claude/` 設定は、これらのディレクトリから[検出されません](/docs/ja/permissions#additional-directories-grant-file-access-not-configuration)。

* **スコープ**: [`Any file`](#scopes)。ただし、プロジェクトおよびローカルのエントリが付与するサンドボックスの書き込みアクセスには[制限](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)があります
* **タイプ**: ディレクトリパスの配列
* **デフォルト**: 未設定
* **セッションごとの上書き**: `--add-dir` および `/add-dir` はこのキーと並行して 1 つのセッションにディレクトリを追加します

```json settings.json theme={null}
{
  "permissions": {
    "additionalDirectories": ["../docs/"]
  }
}
```

`allow` ルールと同様に、プロジェクトの `.claude/settings.json` のエントリは、そのフォルダの[ワークスペース信頼ダイアログ](/docs/ja/permissions#project-allow-rules-and-workspace-trust)を受け入れた後にのみ有効になります。

<h3 id="permissions-blockreadsoutsideworkingdirectories">
  `permissions.blockReadsOutsideWorkingDirectories`
</h3>

`bypassPermissions` を含むすべての権限モードで、Claude のファイルツールが[作業ディレクトリ](/docs/ja/permissions#working-directories)外の読み取りを拒否するようにします。Claude Code はそれらのパスに対する `Read`、`Grep`、`Glob`、`LSP` の呼び出しを拒否し、`/add-dir` でディレクトリを追加するようユーザーに求めるよう Claude に指示します。Claude Code 自体が必要とするファイル（`~/.claude/` の下のスキル、プラグイン、ルール、エージェント、コマンド、`CLAUDE.md` メモリファイルなど）は読み取り可能なままです。Claude Code v2.1.257 以降が必要です。

Claude Code はシェルコマンドを同じ方法では拒否しません。

* [どのモードでも自動承認されないアクション](/docs/ja/permission-modes#actions-no-mode-auto-approves)では、そのようなパスを読み取るシェルコマンドがいつプロンプトを表示するかを説明しています
* [ブロック下のサンドボックス化されたコマンド](#sandboxed-commands-under-the-block)では、サンドボックス化されたコマンドが何を読み取れるかを説明しています

シェルパーサーが追跡できない Bash コマンド（複数回ディレクトリを変更するものやサブシェルを実行するものなど）は、auto モードおよび `bypassPermissions` モードでもプロンプトを表示します。プロンプトは、コマンドが作業ディレクトリ外のパスを指定していない場合でも表示されます。このプロンプトは、コマンドが[サンドボックス](/docs/ja/sandboxing)で実行され、サンドボックスがブロックを強制する場合には適用されません。

また、[作業ディレクトリ外の最初の読み取り前に表示される auto モードのプロンプト](/docs/ja/permission-modes#first-read-outside-the-working-directories)でそのような読み取りをブロックすることを選択した場合も、Claude Code はここに `true` を書き込みます。

* **スコープ**: [`Any file`](#scopes)。いずれかのファイルの `true` が適用されるため、リポジトリは自身に対してブロックをオンにできますが、ユーザーが設定したブロックを解除することはできません。
* **タイプ**: ブール値
  * `true`: Claude のファイルツールは作業ディレクトリ外の読み取りを拒否します
  * `false`: 未設定と同じです。別のファイルが `true` を設定している場合、ブロックは引き続き適用されます
* **デフォルト**: 未設定。作業ディレクトリ外の読み取りは[権限モード](/docs/ja/permission-modes)に従います

```json settings.json theme={null}
{
  "permissions": {
    "blockReadsOutsideWorkingDirectories": true
  }
}
```

`--add-dir`、`/add-dir`、またはユーザー設定や管理設定の `additionalDirectories` で追加したディレクトリは、ブロックにおいて作業ディレクトリとしてカウントされます。リポジトリ設定でのみ追加されたディレクトリはカウントされません。該当するのは `.claude/settings.json` のディレクトリと、git がそのファイルを未追跡として報告する場合を除く `.claude/settings.local.json` のディレクトリです。git リポジトリではないディレクトリ、または git がそのファイルを追跡している場合、Claude Code は `.claude/settings.local.json` をリポジトリ設定として扱うため、読み取り可能にしておきたいディレクトリは代わりにユーザー設定に配置してください。

[`autoMemoryDirectory`](#automemorydirectory)がプロジェクトの `.claude/settings.json` から、または[リポジトリ提供として扱われる](/docs/ja/permissions#when-your-local-settings-file-needs-trust)`.claude/settings.local.json` から来る場合、Claude Code はそのディレクトリから[自動メモリ](/docs/ja/memory#storage-location)を読み込まず、そこに保存もしません。

ブロックを解除するには、それを設定しているすべての設定ファイルからキーを削除し、新しいセッションを開始します。

<h4 id="sandboxed-commands-under-the-block">
  ブロック下のサンドボックス化されたコマンド
</h4>

[サンドボックス化](/docs/ja/sandboxing)がオンの場合、ブロックはサンドボックス化されたコマンドにも適用されます。Claude Code はホームディレクトリおよびユーザーファイルを保持する他のルート（`/Users`、`/home`、`/root`、`/Volumes`、`/mnt`、`/media`、`/run/media`、`/srv`）への読み取りアクセスを拒否します。その後、作業ディレクトリ、Claude Code がセッション中に作成する [worktree](/docs/ja/worktrees)、セッションの一時ディレクトリ、およびコマンドが必要とする `~/.claude` の部分（スキルやプラグインなど）を再度開きます。ブロックが有効な間、リポジトリ設定からの `allowRead` および `allowWrite` エントリはカウントされません。

セッションの作業ディレクトリがリンクされた [git worktree](/docs/ja/worktrees) である場合（Claude Code がセッション中に入ったものを含む）、リポジトリの共通 `.git` ディレクトリはサンドボックス化されたコマンドに対して読み取り可能および書き込み可能なままなので、git はそこで引き続き機能します。

次の場合、ブロックはサンドボックス化されたコマンドには及びませんが、Claude のファイルツールは引き続きそれを強制します。

* ファイルシステム分離が [`sandbox.filesystem.disabled`](#sandbox-filesystem-disabled) によってオフになっている
* [`allowManagedReadPathsOnly`](#sandbox-filesystem-allowmanagedreadpathsonly) が設定されている
* Claude Code を開始したディレクトリのパスに `*`、`?`、`[` などのグロブ文字が含まれている

ブロック下で、Claude Code はサンドボックス化されたコマンドに対してグローバル git 設定ファイルを再度開くため、`git` はユーザーのアイデンティティと設定を保持します。

* `~/.gitconfig`
* `$XDG_CONFIG_HOME/git` の下の `config`、`ignore`、`attributes` ファイル（デフォルトは `~/.config/git`）
* グローバル git 設定が `[include]`、`[includeIf]`、`core.excludesFile`、`core.attributesFile` を通じて指定するファイル

Claude Code は各ファイルを個別に判断します。ファイルが、サンドボックス化されたコマンドが直接またはシンボリックリンクを通じて書き込める場所にある場合、Claude Code はそのファイルが指定するファイルを再度開きません。

Linux および WSL2 では、シンボリックリンクである設定ファイルはそれ自身のパスで読み取り不可のままになることがあり、その場合 `git` はそのファイルなしで実行されます。`~/.git-credentials` および `$XDG_CONFIG_HOME/git/credentials` はブロックされたままです。

再度開いたファイルがシークレット（`http.extraHeader` トークンなど）を保持する場合、そのパスを [`sandbox.filesystem.denyRead`](#sandbox-filesystem-denyread) に追加してください。ファイルをカバーする `denyRead` エントリは、常にこの再度開く処理より優先されます。

<h3 id="permissions-defaultmode">
  `permissions.defaultMode`
</h3>

新しいセッションが開始する[権限モード](/docs/ja/permission-modes)を設定します。未設定のままにすると、セッションは使用しているサーフェスの[組み込みデフォルト](/docs/ja/permission-modes#which-mode-a-session-starts-in)で開始します。

* **スコープ**: [`Any file`](#scopes)。`auto` および `bypassPermissions` はプロジェクトまたはローカル設定からは有効にならないため、代わりに `~/.claude/settings.json` で設定してください。v2.1.257 より前では、`bypassPermissions` は任意のファイルから有効になりました。VS Code 拡張機能が開始する会話の場合、Claude Code はユーザー、管理、および `--settings` の値のみを読み取ります。
* **タイプ**: 文字列。次のいずれか：
  * `"default"`: Claude Code は確認なしで読み取りのみを実行します
  * `"acceptEdits"`: Claude Code は確認なしでファイル編集と `mkdir` や `mv` などの一般的なファイルシステムコマンドも実行します
  * `"plan"`: Claude Code は読み取りと計画を行いますが、計画を承認するまで編集をブロックします
  * `"auto"`: Claude Code は日常的なプロンプトなしで実行します。シェルコマンドやネットワークリクエストなどのアクションが実行される前に、バックグラウンドの分類器がそれらがユーザーのリクエストに沿っているかを確認します
  * `"dontAsk"`: Claude Code はプロンプトを表示するはずのすべての呼び出しを自動的に拒否します。読み取り、承認が不要な他のアクション、事前承認されたツールは引き続き実行されます
  * `"bypassPermissions"`: Claude Code はすべてを確認なしで実行します
  * `"manual"`: `"default"` のエイリアス
* **デフォルト**: 未設定
* **セッションごとの上書き**: `--permission-mode`、および `bypassPermissions` に相当する `--dangerously-skip-permissions` は、1 つのセッションにおいてこのキーより優先されます

```json settings.json theme={null}
{
  "permissions": {
    "defaultMode": "acceptEdits"
  }
}
```

権限ルールはすべてのモードの上に重ねて適用されます。`deny` ルールは `bypassPermissions` を含むすべてのモードでブロックします。[権限モード](/docs/ja/permission-modes)を参照してください。クラウドセッションでは、Claude Code はこのキーのうち `acceptEdits`、`plan`、`default`、`auto` のみを尊重します。VS Code 拡張機能が開始する会話については、[拡張機能が開始権限モードとして読み取る設定](/docs/ja/permission-modes#switch-permission-modes)を参照してください。

<h3 id="permissions-disablebypasspermissionsmode">
  `permissions.disableBypassPermissionsMode`
</h3>

誰も `bypassPermissions` モードに入れないようにします。Claude Code は `--dangerously-skip-permissions` フラグを拒否し、[エージェント定義](/docs/ja/sub-agents#permission-modes)の `permissionMode: bypassPermissions` を無視するため、サブエージェントは親セッションの権限モードで実行されます。

* **スコープ**: [`Any file`](#scopes)。通常、組織のポリシーを強制するために[管理設定](/docs/ja/managed-settings)で設定します。
* **タイプ**: 文字列 `"disable"`
* **デフォルト**: 未設定
* **セッションごとの上書き**: このキーは `--dangerously-skip-permissions` より優先されます。キーが設定されている間、Claude Code はそのフラグを拒否します

```json settings.json theme={null}
{
  "permissions": {
    "disableBypassPermissionsMode": "disable"
  }
}
```

v2.1.223 より前では、Claude Code はバイパスが無効になっていてもフロントマターの権限モードを適用していました。

<h3 id="skipautopermissionprompt">
  `skipAutoPermissionPrompt`
</h3>

組み込みデフォルトによってセッションが auto モードで開始された場合ではなく、ユーザー自身の設定やモードセレクターなどを通じて初めて auto モードに入ったときに Claude Code が表示する、[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)を説明する 1 回限りの通知をスキップします。Claude Code はその通知を 1 回表示した後、表示済みであることを記録するため、このキーは通知がまだ表示されていない場合にのみ意味を持ちます。

* **スコープ**: [`User or managed`](#scopes)。リポジトリがこれを設定することはできません。
* **タイプ**: ブール値
  * `true`: Claude Code は通知をスキップします
  * `false`: 未設定と同じです。これらのファイルのいずれかが `true` を設定しない限り、通知が 1 回表示されます
* **デフォルト**: 未設定。通知が 1 回表示されます

```json settings.json theme={null}
{
  "skipAutoPermissionPrompt": true
}
```

<h3 id="skipdangerousmodepermissionprompt">
  `skipDangerousModePermissionPrompt`
</h3>

`--dangerously-skip-permissions` からか `defaultMode: "bypassPermissions"` からかに関わらず、セッションが `bypassPermissions` モードに入る前に Claude Code が表示する確認ダイアログをスキップします。そのダイアログを一度受け入れると、Claude Code はユーザー設定のこのキーに `true` を書き込みます。

* **スコープ**: [`User, local, or managed`](#scopes)。信頼されていないリポジトリがダイアログをスキップさせることはできません。
* **タイプ**: ブール値
  * `true`: Claude Code はセッションが `bypassPermissions` モードに入る前の確認ダイアログをスキップします
  * `false`: 未設定と同じです。これらのファイルのいずれかが `true` を設定しない限り、ダイアログが表示されます
* **デフォルト**: 未設定。ダイアログが表示されます

```json settings.json theme={null}
{
  "skipDangerousModePermissionPrompt": true
}
```

<h2 id="sandbox-settings">
  サンドボックス設定
</h2>

Claude が実行するコマンドをファイルシステム、ネットワーク、認証情報から分離します。サンドボックスの仕組みとプラットフォーム要件については、[サンドボックス](/docs/ja/sandboxing)を参照してください。

<h3 id="sandbox">
  `sandbox`
</h3>

[サンドボックス](/docs/ja/sandboxing)を使用して、Claude が実行する Bash コマンドをファイルシステムとネットワークから分離します。`enabled` でサンドボックスをオンにしてから、`filesystem`、`network`、`credentials` サブオブジェクトを使用して、サンドボックス化されたコマンドが何にアクセスできるかを制限または拡大します。サンドボックスは macOS、Linux、WSL2 で実行されます。

* **Scope**: [`Any file`](#scopes)
* **Type**: `enabled`、`failIfUnavailable`、`autoAllowBashIfSandboxed`、`excludedCommands`、`allowUnsandboxedCommands`、`enableWeakerNestedSandbox`、`enableWeakerNetworkIsolation`、`allowAppleEvents`、`bwrapPath`、`socatPath`、`ignoreViolations`、`ripgrep` を含むオブジェクト、および `filesystem`、`network`、`credentials` オブジェクト
* **Default**: 未設定。Claude Code はサンドボックスなしでコマンドを実行します

これはサンドボックスをオンにし、サンドボックス化されたコマンドの権限プロンプトをスキップし、`docker` をサンドボックスの外で実行し、2 つの追加の書き込みパスを開き、AWS 認証情報ファイルを非表示にし、GitHub と npm を事前に許可します：

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker *"],
    "filesystem": {
      "allowWrite": ["/tmp/build", "~/.kube"],
      "denyRead": ["~/.aws/credentials"]
    },
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"]
    }
  }
}
```

管理設定が `enabled` や `failIfUnavailable` などのブール値キーを設定した場合、その値は開発者が設定したものをすべて上書きします。Claude Code は配列キーをセッションが読み込む設定スコープ全体でマージするため、開発者はエントリを追加できます。管理設定専用のロックについては、[ポリシーの拡大を開発者に防止させる](/docs/ja/sandboxing#keep-developers-from-widening-the-policy)を参照してください。組織に対してサンドボックスを必須にするには、[管理設定でサンドボックスを強制する](/docs/ja/sandboxing#enforce-sandboxing-with-managed-settings)を参照してください。

<h3 id="sandbox-enabled">
  `sandbox.enabled`
</h3>

Bash コマンドの[サンドボックス](/docs/ja/sandboxing)をオンにします。`/sandbox` パネルでモードを選択すると、Claude Code はこのキーを現在のプロジェクトの `.claude/settings.local.json` に書き込みます。`~/.claude/settings.json` に設定して、すべてのプロジェクトをサンドボックス化します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: ブール値
  * `true`: Claude Code は Bash コマンドをサンドボックス化します
  * `false`: Bash コマンドはサンドボックスなしで実行されます
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true
  }
}
```

Linux と WSL2 では、サンドボックスは `bubblewrap` と `socat` が必要です。[Linux と WSL2 をセットアップする](/docs/ja/sandboxing#set-up-linux-and-wsl2)を参照してください。サンドボックスが起動できない場合、[`failIfUnavailable`](#sandbox-failifunavailable) も設定していない限り、Claude Code はコマンドをサンドボックスなしで実行します。

<h3 id="sandbox-failifunavailable">
  `sandbox.failIfUnavailable`
</h3>

`sandbox.enabled` が `true` であるにもかかわらず、依存関係の不足やプラットフォームの非対応によりサンドボックスが起動できない場合に、Claude Code がスタートアップ時にエラーで終了するようにします。このキーがない場合、Claude Code はコマンドをサンドボックスなしで実行します。セキュリティゲートとしてサンドボックスを必須とする管理対象のデプロイでは、この設定を使用できます。

サンドボックスがサポートしていないプラットフォームでは、このキーがオンの場合、Claude Code は起動しません。[管理設定でサンドボックスを強制する](/docs/ja/sandboxing#enforce-sandboxing-with-managed-settings)を参照してください。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: ブール値
  * `true`: `sandbox.enabled` が `true` であるにもかかわらずサンドボックスが起動できない場合、Claude Code はスタートアップ時にエラーで終了します
  * `false`: サンドボックスが起動できない場合、Claude Code はコマンドをサンドボックスなしで実行します
* **Default**: `false`

これにより、すべての管理対象マシンがコマンドをサンドボックス化するか、起動を拒否します：

```json managed-settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "failIfUnavailable": true
  }
}
```

[管理設定でサンドボックスを強制する](/docs/ja/sandboxing#enforce-sandboxing-with-managed-settings)を参照してください。

<h3 id="sandbox-autoallowbashifsandboxed">
  `sandbox.autoAllowBashIfSandboxed`
</h3>

Claude Code がサンドボックス化された Bash コマンドを権限プロンプトなしで実行できるようにします。サンドボックスで実行できないコマンドは通常の権限フローを通過し、`deny` ルールと `Bash(git push *)` などのコンテンツスコープ付き `ask` ルールは引き続き適用されます。ベアの `Bash` ask ルールはサンドボックス化されたコマンドではスキップされます。これを `false` に設定して、サンドボックス化されたコマンドも通常の権限フローを通すようにします。これは `/sandbox` **Mode** タブが通常権限モードと呼ぶものです。

* **Scope**: [`Any file`](#scopes)
* **Type**: ブール値
  * `true`: Claude Code はサンドボックス化された Bash コマンドを権限プロンプトなしで実行します。`deny` ルールとコンテンツスコープ付き `ask` ルールの対象です。`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` は自動許可をオフにします
  * `false`: サンドボックス化されたコマンドは通常の権限フローを通過するため、許可ルールと権限モードが決定します。`/sandbox` **Mode** タブはこれを通常権限モードと呼びます
* **Default**: `true`

これはサンドボックスをオンに保ち、サンドボックス化されたコマンドを通常の権限フローを通します：

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": false
  }
}
```

[サンドボックスモード](/docs/ja/sandboxing#sandbox-modes)を参照して、自動許可モードが何をプロンプトするか、および plan モードでどのように動作するかを確認してください。

<h3 id="sandbox-excludedcommands">
  `sandbox.excludedCommands`
</h3>

Claude Code がサンドボックスの外で実行するコマンド（サンドボックスで動作しないツールなど）に名前を付けます。各エントリは、`Bash(...)` [権限ルール](/docs/ja/permissions#permission-rule-syntax)の内容と同じ構文を使用します：正確なコマンド、`docker *` などのプレフィックス、またはワイルドカードパターン。ワイルドカードを含まないパターンは完全一致となるため、`docker` は引数なしの `docker` にのみ一致します。

エントリは、Bash 呼び出しのすべてのコマンドをカバーする場合にのみ、Bash 呼び出しをサンドボックスから外します。一部の呼び出し形式はそれでもサンドボックス化されたままです。`docker *` エントリだけでは、`npm ci && docker build .` をサンドボックスから外しません。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: コマンドパターンの配列
* **Default**: 未設定。コマンドは除外されません

```json settings.json theme={null}
{
  "sandbox": {
    "excludedCommands": ["docker *"]
  }
}
```

Claude Code は、Bash 呼び出しが以下のような形状のいずれかを持つ場合、その呼び出しをサンドボックス化したままにします：

* `sudo`、`eval`、または `xargs` で始まるコマンド
* `cd`、`pushd`、または `popd`（呼び出しのどこにでも出現）
* コマンド置換、サブシェル、または `if` や `for` などの制御フロー ブロック
* `docker build . > build.log` など、ファイル記述子を複製するもの以外のリダイレクト（`2>&1` など）
* 変数から来るコマンド名
* パス引数が絶対パスである、`~` で始まる、または `..` セグメントを含む `git clone`、`git init`、`git worktree add`、`git worktree move`、または `git bundle create`

たとえば、`cd build && docker compose up` は `docker *` エントリの下でサンドボックス化されたままであり、`cd` エントリを追加してもそれは変わりません。`git *` エントリの下では、`git clone <url> vendor/lib` はサンドボックスの外で実行されますが、`git clone <url> ~/tools` はサンドボックス化されたままです。クローンは、宛先パスが指す場所に、実行可能なものを含む可能性のあるファイルツリー全体を書き込みます。

除外されたコマンドも通常の権限フローを通過します。除外は便宜的なものであり、セキュリティ境界ではありません。ツールが特定の場所にのみ書き込む必要がある場合は、[`filesystem.allowWrite`](#sandbox-filesystem-allowwrite) を使えばサンドボックス化されたままにできます。

サンドボックスが[管理者必須](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)でない限り、セッションが読み込む設定スコープのエントリは 1 つのリストに結合されます。管理者必須の間、Claude Code は `.claude/settings.json` と `.claude/settings.local.json` のエントリを無視するため、クローンしたリポジトリがコマンドをサンドボックスの外に出すことはできません。管理設定、`--settings`、および `~/.claude/settings.json` のエントリは引き続き適用され、このリストに対する管理設定専用のロックはありません。

<h3 id="sandbox-allowunsandboxedcommands">
  `sandbox.allowUnsandboxedCommands`
</h3>

サンドボックスによってブロックされた後、Claude が `dangerouslyDisableSandbox` パラメータを使用してコマンドをサンドボックスの外で再試行できるようにします。`false` の場合、Claude Code はそのパラメータを無視します。その結果、サンドボックスの実行中は、Claude が実行するコマンドは [`excludedCommands`](#sandbox-excludedcommands) のエントリに一致しない限りサンドボックス化されます。`/sandbox` **Overrides** タブはその状態を**厳密なサンドボックスモード**として表示します。管理設定で `false` にすると、その対象となる開発者に対して厳密なサンドボックスモードがオンになります。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#turn-off-the-retry-with-strict-sandbox-mode)）
* **Type**: ブール値
  * `true`: Claude がサンドボックスによってブロックされた後、`dangerouslyDisableSandbox` パラメータを使用してコマンドをサンドボックスの外で再試行できます
  * `false`: Claude Code はそのパラメータを無視するため、サンドボックスの実行中は、Claude が実行するコマンドは `excludedCommands` のエントリに一致しない限りサンドボックス化されます
* **Default**: `true`

これにより、管理設定がカバーするすべてのユーザーに対して厳密なサンドボックスモードが強制されます：

```json managed-settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "allowUnsandboxedCommands": false
  }
}
```

管理設定または `--settings` からの `false` は、サンドボックスを[管理者必須](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)にもします。ユーザー設定の `false` はプロジェクトの `true` よりも優先されますが、サンドボックスを管理者必須にはしません。プロジェクトの値よりも優先させるには Claude Code v2.1.285 以降が必要です。

サンドボックスなしの再試行を誰が承認するかは、権限モードと許可ルールによって決まります。[サンドボックスなしの再試行エスケープハッチ](/docs/ja/sandboxing#the-unsandboxed-retry-escape-hatch)を参照してください。

[`!` シェルモードプロンプト](/docs/ja/interactive-mode#shell-mode-with-prefix)で自分で入力するコマンドがサンドボックス化されるときを確認するには、[厳密なサンドボックスモード](/docs/ja/sandboxing#turn-off-the-retry-with-strict-sandbox-mode)を参照してください。

<h3 id="sandbox-filesystem">
  `sandbox.filesystem`
</h3>

サンドボックス化されたコマンドが読み取りおよび書き込みできるパスを制御します。デフォルトでは、作業ディレクトリ、ユーザーごとの一時ディレクトリ、`--add-dir`、`/add-dir`、または `permissions.additionalDirectories` で追加したディレクトリに書き込むことができ、認証情報ファイルを含むファイルシステムの残りの部分を読み取ることができます。4 つのパスリストで制限または拡大するか、`disabled` でファイルシステムレイヤーをオフにします。[ファイルシステム分離](/docs/ja/sandboxing#filesystem-isolation)のデフォルト境界を参照してください。

* **Scope**: [`Any file`](#scopes)
* **Type**: `allowWrite`、`denyWrite`、`denyRead`、`allowRead` 配列を含むオブジェクト、および `allowManagedReadPathsOnly` と `disabled` ブール値
* **Default**: 未設定。デフォルトの読み取りおよび書き込み境界が適用されます

これにより、サンドボックス化されたコマンドはビルドディレクトリと kubeconfig に書き込むことができ、AWS 認証情報ファイルを非表示にします：

```json settings.json theme={null}
{
  "sandbox": {
    "filesystem": {
      "allowWrite": ["/tmp/build", "~/.kube"],
      "denyRead": ["~/.aws/credentials"]
    }
  }
}
```

Claude Code はこれらのリストを OS サンドボックス境界で強制するため、`kubectl`、`terraform`、`npm` などのサンドボックス化されたコマンドが開始するすべてのサブプロセスに適用されます。Claude Code は[権限ルール](/docs/ja/sandboxing#permission-rules)を同じリストに追加します：`Edit` 許可および拒否ルールを `allowWrite` および `denyWrite` に、`Read` 拒否ルールを `denyRead` に、`WebFetch(domain:...)` 許可および拒否ルールを[`network`](#sandbox-network)ドメインリストに追加します。

ロックが適用されない限り、Claude Code はセッションが読み込む設定ファイル全体でこれらのリストをマージします。[`allowManagedReadPathsOnly`](#sandbox-filesystem-allowmanagedreadpathsonly)は `allowRead` を管理設定からのエントリに制限し、[`allowManagedDomainsOnly`](#sandbox-network-allowmanageddomainsonly)は許可されたドメインに対して同じことを行います。[リポジトリロック](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)は、リポジトリの設定ファイルからのエントリを除外します。

[サンドボックスを設定する](/docs/ja/sandboxing#configure-sandboxing)は、`--setting-sources` で除外するソースをカバーしています。セッション中にリストを編集すると、Claude Code は[実行中のセッションに変更を適用](/docs/ja/settings#when-edits-take-effect)します。

<h4 id="sandbox-path-prefixes">
  サンドボックスパスプレフィックス
</h4>

`allowWrite`、`denyWrite`、`denyRead`、`allowRead`、および [`credentials.files`](#sandbox-credentials-files) のパスはプレフィックスで解決されます：

| プレフィックス | 意味 | 例 |
| :- | :- | :- |
| `/` | ファイルシステムルートからの絶対パス | `/tmp/build` は `/tmp/build` のままです |
| `~/` | ホームディレクトリに相対 | `~/.kube` は `$HOME/.kube` になります |
| `./` またはプレフィックスなし | プロジェクト設定ではプロジェクトルートに相対、ユーザー設定では `~/.claude` に相対 | `.claude/settings.json` の `./output` は `<project-root>/output` に解決されます |

絶対パスの `//path` プレフィックスも機能します。プロジェクト相対解決を期待して単一スラッシュ `/path` を使用する場合は、`./path` に切り替えます。この構文は、`//path` を絶対パスに、`/path` をプロジェクト相対に使用する[Read および Edit 権限ルール](/docs/ja/permissions#read-and-edit)とは異なります。サンドボックスファイルシステムパスは標準規則を使用するため、`/tmp/build` は絶対パスです。

Claude Code はディレクトリパスから末尾のスラッシュを削除するため、`~/.aws` と `~/.aws/` は同じディレクトリと一致します。v2.1.224 より前では、Claude Code は末尾のスラッシュをサンドボックスに渡していたため、末尾のスラッシュ付きで記述された `denyRead` または `denyWrite` エントリの下のパスを、Claude が引き続き読み取りまたは書き込みできました。

Claude Code は末尾の `/**` も削除するため、`~/build/**` と `~/build` は同じディレクトリをカバーします。`*` などのワイルドカードが機能するかどうかは、エントリがどのリストにあるか、およびプラットフォームに依存します：

* **`allowWrite` および `denyWrite`**: macOS ではワイルドカードが機能します。Linux と WSL2 では、サンドボックスは具体的なパスをマウントするため、Claude Code は末尾の `/**` を削除した後に `*`、`?`、または `[` を含むエントリをスキップし、そのエントリは効果がありません。Claude Code は `Edit` 権限ルールからパスを追加するため、同じ制限が適用され、`/sandbox` の **Config** タブはワイルドカードを含む `Edit` および `Read` 権限ルールについて警告します。
* **`denyRead` および `allowRead`**: ワイルドカードはすべてのプラットフォームで機能します。Linux と WSL2 では、Claude Code は読み取りエントリを、それが一致する具体的なパスに展開します。これは書き込みリストでは行いません。

<h3 id="sandbox-filesystem-allowwrite">
  `sandbox.filesystem.allowWrite`
</h3>

作業ディレクトリ、ユーザーごとの一時ディレクトリ、`--add-dir`、`/add-dir`、または `permissions.additionalDirectories` で追加したディレクトリを超えて、サンドボックス化されたコマンドが書き込むことができるパスを追加します。`kubectl` やビルドツールなどのサブプロセスがプロジェクト外に書き込む必要がある場合に使用します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: [サンドボックスパスプレフィックス](#sandbox-path-prefixes)を使用するパス文字列の配列
* **Default**: 未設定。サンドボックス化されたコマンドは、作業ディレクトリ、ユーザーごとの一時ディレクトリ、`--add-dir` または `/add-dir` で追加したディレクトリ、および [`permissions.additionalDirectories`](#permissions-additionaldirectories) のディレクトリに書き込むことができます

これにより、ビルドは `/tmp/build` の下に書き込むことができ、`kubectl` は kubeconfig を更新できます：

```json settings.json theme={null}
{
  "sandbox": {
    "filesystem": {
      "allowWrite": ["/tmp/build", "~/.kube"]
    }
  }
}
```

Claude Code は `allowWrite` エントリと `Edit(...)` 許可権限ルールからのパスをセッションが読み込むすべての設定スコープ全体でマージし、[`permissions.blockReadsOutsideWorkingDirectories`](#sandboxed-commands-under-the-block)がオンの間、リポジトリ設定からのものを除外します。[リポジトリロック](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)によってリポジトリのエントリが除外されることもあります。`allowWrite` エントリは[保護されたパス](/docs/ja/sandboxing#protected-paths)を解除できません。

<h3 id="sandbox-filesystem-denywrite">
  `sandbox.filesystem.denyWrite`
</h3>

サンドボックス化されたコマンドが特定のパスへの書き込みをブロックします。これには、別の方法で書き込み可能なディレクトリ内のパスが含まれます。

* **Scope**: [`Any file`](#scopes)
* **Type**: [サンドボックスパスプレフィックス](#sandbox-path-prefixes)を使用するパス文字列の配列
* **Default**: 未設定

これにより、サンドボックス化されたコマンドがシステム設定を変更したり、バイナリをインストールしたりするのを防ぎます：

```json settings.json theme={null}
{
  "sandbox": {
    "filesystem": {
      "denyWrite": ["/etc", "/usr/local/bin"]
    }
  }
}
```

Claude Code はセッションが読み込むすべての設定スコープ全体でエントリをマージし、`Edit(...)` 拒否権限ルールからのパスを追加します。

<h3 id="sandbox-filesystem-denyread">
  `sandbox.filesystem.denyRead`
</h3>

サンドボックス化されたコマンドが特定のパス（デフォルトの読み取りポリシーが公開する認証情報ファイルなど）の読み取りをブロックします。認証情報ファイルを保護し、サンドボックスプロキシを通じて使用可能に保つには、代わりに [`sandbox.credentials`](#sandbox-credentials) を参照してください。

* **Scope**: [`Any file`](#scopes)
* **Type**: [サンドボックスパスプレフィックス](#sandbox-path-prefixes)を使用するパス文字列の配列
* **Default**: 未設定。サンドボックス化されたコマンドは[デフォルト読み取りアクセス](/docs/ja/sandboxing#filesystem-isolation)を保持します。これには `~/.aws/credentials` などの認証情報ファイルが含まれます

```json settings.json theme={null}
{
  "sandbox": {
    "filesystem": {
      "denyRead": ["~/.aws/credentials"]
    }
  }
}
```

Claude Code はセッションが読み込むすべての設定スコープ全体でエントリをマージし、`Read(...)` 拒否権限ルールからのパスを追加します。[`filesystem.disabled`](#sandbox-filesystem-disabled)が `true` の場合、Claude Code はこれらのエントリを強制しません。

<h3 id="sandbox-filesystem-allowread">
  `sandbox.filesystem.allowRead`
</h3>

[`denyRead`](#sandbox-filesystem-denyread)がブロックする領域内の特定のパスの読み取りを再度開き、ワークスペースのみの読み取りアクセスを構築します。正確またはワイルドカード `denyRead` エントリは、より広い `allowRead` 内でブロックされたままです。[重複テーブル](/docs/ja/sandboxing#configure-sandboxing)が示すとおりです。ワイルドカード `denyRead` エントリ（`~/**/.env` など）がディレクトリと一致する場合、Claude Code はその内容の読み取りもブロックします。v2.1.236 より前の macOS では、Claude Code はワイルドカード `denyRead` エントリが一致したパスを、より広い `allowRead` エントリがカバーしている場所で再度開き、一致したディレクトリの内容を読み取り可能なままにしました。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: [サンドボックスパスプレフィックス](#sandbox-path-prefixes)を使用するパス文字列の配列
* **Default**: 未設定

これにより、プロジェクト自体を除くホームディレクトリの読み取りがブロックされます：

```json settings.json theme={null}
{
  "sandbox": {
    "filesystem": {
      "denyRead": ["~/"],
      "allowRead": ["."]
    }
  }
}
```

Claude Code は `.` エントリをプロジェクト設定ではプロジェクトルートに、ユーザー設定では `~/.claude` に解決します。[`allowManagedReadPathsOnly`](#sandbox-filesystem-allowmanagedreadpathsonly) が設定されていない限り、Claude Code はセッションが読み込む設定ファイル全体でエントリをマージし、[`permissions.blockReadsOutsideWorkingDirectories`](#sandboxed-commands-under-the-block) がオンの間はリポジトリ設定からのエントリを除外します。[リポジトリロック](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)によってリポジトリのエントリが除外されることもあります。

<h3 id="sandbox-filesystem-allowmanagedreadpathsonly">
  `sandbox.filesystem.allowManagedReadPathsOnly`
</h3>

管理設定から来る [`allowRead`](#sandbox-filesystem-allowread) エントリのみを尊重するため、開発者は組織がブロックしたパスへの読み取りアクセスを再度開くことができません。Claude Code は引き続きセッションが読み込むすべての設定スコープから `denyRead` エントリをマージします。

* **Scope**: [`Managed`](#scopes)
* **Type**: ブール値
  * `true`: Claude Code は管理設定からの `allowRead` エントリのみを尊重します
  * `false`: 他の設定ファイルからの `allowRead` エントリもマージされます
* **Default**: `false`

これにより、ホームディレクトリの読み取りがブロックされ、`~/work` が再度開かれ、開発者が他のものを再度開くのが停止されます：

```json managed-settings.json theme={null}
{
  "sandbox": {
    "filesystem": {
      "denyRead": ["~/"],
      "allowRead": ["~/work"],
      "allowManagedReadPathsOnly": true
    }
  }
}
```

[ポリシーの拡大を開発者に防止させる](/docs/ja/sandboxing#keep-developers-from-widening-the-policy)を参照してください。

<h3 id="sandbox-filesystem-disabled">
  `sandbox.filesystem.disabled`
</h3>

ネットワーク分離を保持しながらファイルシステム分離をスキップします。サンドボックス化されたコマンドはホストファイルシステムへの無制限の読み取りおよび書き込みアクセスを取得し、それらのネットワーク出力は [`network.allowedDomains`](#sandbox-network-alloweddomains) に限定されたままです。コマンドが何を書き込むかではなく、どこに接続するかを制御するためにサンドボックスを使用する場合に使用します。Claude Code v2.1.216 以降が必要です。

* **Scope**: [`User or managed`](#scopes)。管理設定が `sandbox.filesystem` をまったく設定する場合、または `"mode": "deny"` を持つ `sandbox.credentials.files` エントリをリストする場合、管理設定のみがそれを設定できます。
* **Type**: ブール値
  * `true`: Claude Code はファイルシステム分離をスキップし、ネットワーク分離を保持します
  * `false`: ファイルシステム分離は有効なままです
* **Default**: `false`。ファイルシステム分離は有効なままです

これにより、ファイルシステムが開かれ、ネットワーク出力が GitHub と npm に限定されます：

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "filesystem": {
      "disabled": true
    },
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"]
    }
  }
}
```

レイヤーがオフの場合、Claude Code は `denyRead` または `credentials.files` `deny` エントリを強制しませんが、`credentials.envVars` エントリと適用された `mask` エントリは引き続き機能します。[`autoAllowBashIfSandboxed`](#sandbox-autoallowbashifsandboxed)は引き続き `true` にデフォルト設定されるため、プロンプトを続けるには `false` に設定します。[ファイルシステム分離を無効にする](/docs/ja/sandboxing#disable-filesystem-isolation)を参照して、それを設定できるソースの完全なリストと、分離がオフの場合に何が変わるかを確認してください。Claude Code v2.1.216 以降が必要です。

<h3 id="sandbox-ignoreviolations">
  `sandbox.ignoreViolations`
</h3>

コマンドがプローブして拒否されることが予想されるパスのサンドボックス違反レポートを沈黙させます（例えば、スタートアップ時に `/etc/hosts` をチェックするツール）。これらの拒否は違反として表示されず、Claude が見るものにも表示されません。サンドボックスはアクセスをブロックしたままです。レポートのみが抑制されます。キーはコマンドに対して一致するサブストリング（`*` はすべてのコマンドに一致）で、値はそのコマンドで無視する違反のサブストリング（ファイルシステムパスなど）です。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: コマンドサブストリングを違反サブストリングの配列にマップするオブジェクト（通常はパス）
* **Default**: 未設定。すべての違反が報告されます

```json settings.json theme={null}
{
  "sandbox": {
    "ignoreViolations": {
      "*": ["/etc/hosts"]
    }
  }
}
```

<h3 id="sandbox-enableweakernestedsandbox">
  `sandbox.enableWeakerNestedSandbox`
</h3>

Linux サンドボックスを非特権 Docker コンテナ内で実行します。bubblewrap は新しい `/proc` をマウントできません。代わりに、内部サンドボックスはコンテナの既存の `/proc` をバインドマウントします。これにより、新しいマウントが非表示にするプロセス情報が公開されます。これはセキュリティを低下させます。外部コンテナが既に必要な分離を提供する場合にのみ使用します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: ブール値
  * `true`: 内部サンドボックスは新しい `/proc` をマウントする代わりに、コンテナの既存の `/proc` をバインドマウントします
  * `false`: サンドボックスは新しい `/proc` をマウントします。これは非特権 Docker コンテナでは機能しません
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "enableWeakerNestedSandbox": true
  }
}
```

Linux と WSL2 のみ。[Bubblewrap がコンテナ内で起動に失敗する](/docs/ja/sandboxing#bubblewrap-fails-to-start-inside-a-container)を参照してください。

<h3 id="sandbox-enableweakernetworkisolation">
  `sandbox.enableWeakerNetworkIsolation`
</h3>

macOS でサンドボックス化されたコマンドがシステム TLS トラストサービス `com.apple.trustd.agent` に到達できるようにします。`gh`、`gcloud`、`terraform` などの Go ベースのツールは、[`network.httpProxyPort`](#sandbox-network-httpproxyport)を MITM プロキシとカスタム CA で使用する場合、TLS 証明書を検証するために必要です。これはトラストサービスを通じた潜在的なデータ流出パスを開くことでセキュリティを低下させます。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: ブール値
  * `true`: macOS でサンドボックス化されたコマンドは `com.apple.trustd.agent` に到達できます
  * `false`: macOS でサンドボックス化されたコマンドはシステム TLS トラストサービスに到達できません
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "enableWeakerNetworkIsolation": true
  }
}
```

MITM プロキシを使用しない場合は、代わりに失敗するツールを [`excludedCommands`](#sandbox-excludedcommands) にリストします。[Go ベースの CLI が macOS で TLS 検証に失敗する](/docs/ja/sandboxing#go-based-clis-fail-tls-verification-on-macos)を参照してください。

<h3 id="sandbox-allowappleevents">
  `sandbox.allowAppleEvents`
</h3>

macOS でサンドボックス化されたコマンドが Apple Events を送信できるようにします。`open`、`osascript`、およびブラウザで URL を開くツールはこれが必要です。これがないと、エラー `-600` で失敗します。これはコード実行分離を削除します。サンドボックス化されたコマンドはユーザープロンプトなしで他のアプリケーションを非サンドボックス化で起動でき、Terminal などの実行中のアプリケーションに AppleScript コマンドを送信できます。これはアプリごとの macOS オートメーション同意プロンプト（TCC）の対象です。

* **Scope**: [`User or managed`](#scopes)
* **Type**: ブール値
  * `true`: macOS でサンドボックス化されたコマンドは Apple Events を送信できます
  * `false`: macOS でサンドボックス化されたコマンドは Apple Events を送信できないため、`open` と `osascript` はエラー `-600` で失敗します
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "allowAppleEvents": true
  }
}
```

分離を保持しながら 1 つのそのようなツールを実行するには、代わりに [`excludedCommands`](#sandbox-excludedcommands) に追加します。[macOS の Apple Events](/docs/ja/sandboxing#security-limitations)を参照してください。

<h3 id="sandbox-ripgrep">
  `sandbox.ripgrep`
</h3>

Claude Code が使用するものの代わりに、独自の ripgrep バイナリをサンドボックスに指定します。たとえば、プラットフォームが異なる方法でビルドされた `rg` を必要とする場合です。

* **Scope**: [`User or managed`](#scopes)
* **Type**: ripgrep バイナリへのパスである `command` を含むオブジェクト、および前置する引数の配列である optional `args`
* **Default**: 未設定。サンドボックスは Claude Code と同じ ripgrep バイナリを使用します。[`USE_BUILTIN_RIPGREP`](/docs/ja/env-vars)を `0` に設定しない限り、これはバンドルされたバイナリです

```json settings.json theme={null}
{
  "sandbox": {
    "ripgrep": {
      "command": "/usr/local/bin/rg"
    }
  }
}
```

<h3 id="sandbox-bwrappath">
  `sandbox.bwrapPath`
</h3>

`PATH` の外にインストールされた bubblewrap バイナリ（エアギャップホスト上のベンダー版など）をサンドボックスに指定します。Claude Code はスタートアップ依存関係チェックと、サンドボックス化された各コマンドをラップするときの両方でパスを使用します。

* **Scope**: [`Managed`](#scopes)。Claude Code はユーザー、プロジェクト、またはローカルファイルがサンドボックスを別のバイナリに指定できないように、管理設定からのみ読み取ります。
* **Type**: 文字列。絶対パス。Claude Code は相対パスを削除し、`PATH` ルックアップにフォールバックします
* **Default**: 未設定。Claude Code は `PATH` で `bwrap` を見つけます

```json managed-settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "bwrapPath": "/opt/admin/bwrap"
  }
}
```

Linux と WSL2 のみ。

<h3 id="sandbox-socatpath">
  `sandbox.socatPath`
</h3>

`PATH` の外にインストールされた `socat` バイナリをサンドボックスネットワークプロキシに指定します。

* **Scope**: [`Managed`](#scopes)
* **Type**: 文字列。絶対パス。Claude Code は相対パスを削除し、`PATH` ルックアップにフォールバックします
* **Default**: 未設定。Claude Code は `PATH` で `socat` を見つけます

```json managed-settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "socatPath": "/opt/admin/socat"
  }
}
```

Linux と WSL2 のみ。

<h3 id="sandbox-credentials">
  `sandbox.credentials`
</h3>

[サンドボックス化されたコマンドから保護する](/docs/ja/sandboxing#protect-credentials)認証情報ファイルと環境変数を宣言します。各エントリはファイル `path` または変数 `name` と `mode` に名前を付けます：`deny` はサンドボックス内の認証情報を非表示にし、`mask` はサンドボックス化されたコマンドにプレースホルダーを表示します。[サンドボックスプロキシ](/docs/ja/sandboxing#mask-credentials)は送信リクエストで実際の値を置き換えます。Claude Code はリストしたエントリのみを保護します。組み込みの認証情報拒否リストはありません。

* **Scope**: [`Any file`](#scopes)。Claude Code は `mask` エントリ、`allowPlaintextInject`、`awsPairs`、`sigv4` をユーザー設定、管理設定、`--settings` フラグからのみ尊重します。
* **Type**: `files`、`envVars`、`allowPlaintextInject`、`awsPairs`、`sigv4` を含むオブジェクト
* **Default**: 未設定。認証情報は保護されません

これにより、AWS 認証情報ファイルが非表示になり、`GITHUB_TOKEN` がサンドボックス化されたコマンドから削除されます：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "files": [{ "path": "~/.aws/credentials", "mode": "deny" }],
      "envVars": [{ "name": "GITHUB_TOKEN", "mode": "deny" }]
    }
  }
}
```

`deny` ファイル保護はファイルシステムレイヤーの一部であるため、[ファイルシステム分離を無効にする](/docs/ja/sandboxing#disable-filesystem-isolation)場合は適用されません。環境変数保護は引き続き適用されます。

<h4 id="invalid-credential-entries-in-managed-settings">
  管理設定の無効な認証情報エントリ
</h4>

管理対象の `sandbox.credentials` エントリが検証に失敗した場合、Claude Code は可能な限り認証情報を保護し続けます：

* `files` または `envVars` のエントリで、有効な `path` または `name` と `mask` または `deny` の `mode` を持つもの（キャプチャグループがない `extract` パターンなど）は、警告とともに `mode: "deny"` に低下されるため、認証情報はマスクされず、エントリを修正するまでブロックされたままです。低下した `files` エントリは、明示的な `deny` エントリのように [`filesystem.disabled`](/docs/ja/sandboxing#disable-filesystem-isolation) をピンします。警告は、管理設定がファイルシステム分離をオフにする場合、その読み取りブロックが強制されないことを記します。
* 不明な `mode` または無効な `path` または `name` を持つエントリは削除されます。
* 各ケースは警告します。エントリが低下または削除されるかどうかに関わらず、残りの有効なエントリは引き続き強制され、完全に無効な `credentials` 値は削除されますが、`sandbox` の残りは引き続き適用されます。

v2.1.191 以降に適用されます。v2.1.221 より前では、すべての無効なエントリが削除されました。フィールドごとの処理を持つ他の管理キーについては、[管理設定の無効なエントリ](/docs/ja/managed-settings#invalid-entries-in-managed-settings)を参照してください。

<h3 id="sandbox-credentials-files">
  `sandbox.credentials.files`
</h3>

認証情報ファイルまたはディレクトリをサンドボックス化されたコマンドから保護します。`"mode": "deny"` の場合、Claude Code はサンドボックス内のパスの読み取りをブロックします。これは [`sandbox.filesystem.denyRead`](#sandbox-filesystem-denyread) と同じ読み取りブロックです。`"mode": "mask"` の場合、Linux と WSL2 でサンドボックス化されたコマンドはファイルのセンチネルコピーを読み取り、サンドボックスプロキシはそのエントリの `injectHosts` への送信リクエストで実際の値を置き換えます。macOS ではファイルはサンドボックス内で読み取り不可です。`"mode": "mask"` には Claude Code v2.1.221 以降が必要です。

* **Scope**: [`Any file`](#scopes)。Claude Code はプロジェクト `.claude/settings.json` とローカル `.claude/settings.local.json` から `mask` エントリを削除します。
* **Type**: オブジェクトの配列。各オブジェクトは `path` と `"deny"` または `"mask"` の `mode`、および optional [ファイルのマスクフィールド](#mask-fields-for-files)を含みます
* **Default**: 未設定。認証情報ファイルは保護されません

これにより、AWS 認証情報ファイルが非表示になり、`gh` ホストファイルがマスクされ、`api.github.com` へのリクエストでのみ実際の値が置き換えられます：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "files": [
        { "path": "~/.aws/credentials", "mode": "deny" },
        { "path": "~/.config/gh/hosts.yml", "mode": "mask", "injectHosts": ["api.github.com"] }
      ]
    }
  }
}
```

パスは `sandbox.filesystem.*` 設定と同じ[プレフィックス](#sandbox-path-prefixes)を使用し、Claude Code はセッションが読み込むすべての設定スコープから配列をマージします。[認証情報を保護する](/docs/ja/sandboxing#protect-credentials)は、`--setting-sources` で除外するソースから何が引き続き適用されるかをカバーしています。`mask` エントリには Claude Code v2.1.221 以降が必要です。

`mask` 置換はサンドボックスプロキシを通じてのみ実行されるため、[`sandbox.network.tlsTerminate`](#sandbox-network-tlsterminate)、または プレーン HTTP テストネットワークの場合は [`allowPlaintextInject`](#sandbox-credentials-allowplaintextinject) を設定します。`mask` は単一ファイルに適用されるため、各認証情報ファイルを個別にリストします。Claude Code は `deny` エントリの `mask` フィールドを受け入れますが、無視します。[認証情報をマスクする](/docs/ja/sandboxing#mask-credentials)はどの設定ソースが尊重されるかを、[認証情報ファイルをマスクする](/docs/ja/sandboxing#mask-credential-files)はエントリが `deny` にフォールバックするときをカバーしています。

<span id="sandbox-credentials-files-extract" />

<span id="sandbox-credentials-files-onextractnomatch" />

<span id="sandbox-credentials-files-decode" />

<span id="sandbox-credentials-files-maskclaims" />

<span id="sandbox-credentials-files-maskduplicates" />

<span id="sandbox-credentials-files-injecthosts" />

<h4 id="mask-fields-for-files">
  ファイルのマスクフィールド
</h4>

`mask` エントリはこれらの optional フィールドを受け入れます。`extract` または `decode` がない場合、Claude Code はファイル全体の内容を 1 つのセンチネルで置き換えます。ファイルシステム分離がオンの macOS では、Claude Code は `extract` または `decode` が実行される前に `mask` エントリを `deny` として適用します。[認証情報ファイルをマスクする](/docs/ja/sandboxing#mask-credential-files)を参照してください。

| フィールド | 型 | 何をするか |
| :- | :- | :- |
| `extract` | 文字列。少なくとも 1 つのキャプチャグループを持つ正規表現 | 各一致のグループ 1 でキャプチャされたテキストのみをマスクするため、ファイルの残りは解析可能なままです。`decode` も設定されている場合、Claude Code は各キャプチャを置き換える前に、可能な JWT として確認します。v2.1.221 以降が必要です |
| `onExtractNoMatch` | `"warn"`、`"deny"`、または `"error"`。デフォルト `"warn"` | `extract` または `decode` がマスクするものを見つけられない場合に何が起こるか。`warn` はファイルをサンドボックス内で読み取り可能なままにし、`deny` は読み取り不可にし、`error` は設定を修正するまでサンドボックスセットアップを停止します。Claude Code は、読み取りブロックが強制されない場合、`deny` を `error` として扱います。[ファイルシステム分離を無効にする](/docs/ja/sandboxing#disable-filesystem-isolation)か、[`sandbox.filesystem.allowRead`](#sandbox-filesystem-allowread)エントリがパスを再度開く場合です。v2.1.221 以降が必要です。`decode` ケースには v2.1.224 以降が必要です |
| `decode` | 文字列 `"jwt"` | ファイル内の JSON Web Token（JWT）を見つけます。組み込みパターンまたは設定されている場合は `extract` を使用して、各候補を検証し、構造的に有効な偽のトークンで置き換えます。サンドボックス内のコードがトークンをデコードし続けるようにします。候補が検証されない場合、`onExtractNoMatch` が結果を管理します。v2.1.224 以降が必要です |
| `maskClaims` | 文字列の配列。少なくとも 1 つのクレーム名。`decode` が必要 | 各検証済み JWT 内の名前付きトップレベルペイロードクレームのみをマスクし、変更されたペイロードの周りにトークンを再構築します。他のクレームは読み取り可能なままです。名前付きクレームが一致しない場合、`onExtractNoMatch` が結果を管理します。v2.1.224 以降が必要です |
| `maskDuplicates` | ブール値。デフォルト `false` | 各マスクされた値の逐語的なコピーをファイル内の他の場所でも置き換えます。例えば、コメントに貼り付けられたシークレット。Claude Code は生のサブストリングと一致するため、長く、高エントロピーのシークレット用に予約します。`extract` または `decode` が設定されている場合にのみ参照されます。v2.1.221 以降が必要です |
| `injectHosts` | 文字列の配列。各ホストは [`sandbox.network.allowedDomains`](#sandbox-network-alloweddomains) も認めます | サンドボックスプロキシが実際の値を置き換えるホストを絞ります。未設定の場合、プロキシは `sandbox.network.allowedDomains` のすべてのホストへのリクエストで置き換えます。v2.1.221 以降が必要です |

これにより、`gh` ホストファイル内の `oauth_token` 値のみがマスクされ、ファイル内のそれぞれの他のコピーが置き換えられ、パターンが何も一致しない場合はファイルが読み取り不可になり、実際のトークンは `api.github.com` へのリクエストでのみ置き換えられます：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "files": [
        {
          "path": "~/.config/gh/hosts.yml",
          "mode": "mask",
          "extract": "oauth_token:\\s*(\\S+)",
          "maskDuplicates": true,
          "onExtractNoMatch": "deny",
          "injectHosts": ["api.github.com"]
        }
      ]
    }
  }
}
```

<h3 id="sandbox-credentials-envvars">
  `sandbox.credentials.envVars`
</h3>

環境変数をサンドボックス化されたコマンドから保護します。`"mode": "deny"` の場合、Claude Code はサンドボックス化されたコマンドの環境から変数を削除します。`"mode": "mask"` の場合、サンドボックス化されたコマンドはセッションごとのセンチネル値を見て、サンドボックスプロキシはそのエントリの `injectHosts` への送信リクエストで実際の値を置き換えます。`gh` や `npm` などのツールは実際の認証情報を保持することなく認証を続けます。

* **Scope**: [`Any file`](#scopes)。Claude Code はプロジェクト `.claude/settings.json` とローカル `.claude/settings.local.json` から `mask` エントリを削除します。
* **Type**: オブジェクトの配列。各オブジェクトは `name` と `"deny"` または `"mask"` の `mode`、および optional [環境変数のマスクフィールド](#mask-fields-for-environment-variables)を含みます
* **Default**: 未設定。環境変数は保護されません

これにより、`NPM_TOKEN` がサンドボックス化されたコマンドから削除され、`GITHUB_TOKEN` がマスクされ、実際の値は `api.github.com` へのリクエストでのみ置き換えられます：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "envVars": [
        { "name": "NPM_TOKEN", "mode": "deny" },
        { "name": "GITHUB_TOKEN", "mode": "mask", "injectHosts": ["api.github.com"] }
      ]
    }
  }
}
```

`name` は文字または下線で始まり、文字、数字、下線のみを含む必要があります。Claude Code はセッションが読み込むすべての設定スコープから配列をマージし、同じ変数が両方のモードで表示される場合は `deny` を適用します。[認証情報を保護する](/docs/ja/sandboxing#protect-credentials)は、`--setting-sources` で除外するソースから何が引き続き適用されるかをカバーしています。

`mask` 置換はサンドボックスプロキシを通じてのみ実行されるため、[`sandbox.network.tlsTerminate`](#sandbox-network-tlsterminate)、または プレーン HTTP テストネットワークの場合は [`allowPlaintextInject`](#sandbox-credentials-allowplaintextinject) を設定します。[認証情報をマスクする](/docs/ja/sandboxing#mask-credentials)を参照してください。Claude Code は `deny` エントリの `mask` フィールドを受け入れますが、無視します。

<span id="sandbox-credentials-envvars-extract" />

<span id="sandbox-credentials-envvars-onextractnomatch" />

<span id="sandbox-credentials-envvars-decode" />

<span id="sandbox-credentials-envvars-maskclaims" />

<span id="sandbox-credentials-envvars-injecthosts" />

<h4 id="mask-fields-for-environment-variables">
  環境変数のマスクフィールド
</h4>

`mask` エントリはこれらの optional フィールドを受け入れます。`extract` または `decode` がない場合、Claude Code は全体の値を 1 つのセンチネルで置き換えます。`extract` と `decode` は同じエントリで組み合わせることはできません。

| フィールド | 型 | 何をするか |
| :- | :- | :- |
| `extract` | 文字列。少なくとも 1 つのキャプチャグループを持つ正規表現 | 各一致のグループ 1 でキャプチャされたテキストのみをマスクします。例えば、`DATABASE_URL` 接続文字列内のパスワード。値の残りは解析可能なままです。v2.1.224 以降が必要です |
| `onExtractNoMatch` | `"warn"`、`"deny"`、または `"error"`。デフォルト `"warn"`。`decode` を持つエントリでは、`"warn"` のみが受け入れられます | `extract` が何も一致しない場合に何が起こるか。`warn` は変数をマスクなしで渡し、`deny` はサンドボックス内でそれをアンセットし、`error` は設定を修正するまでサンドボックスセットアップを停止します。v2.1.224 以降が必要です |
| `decode` | 文字列 `"jwt"` | 全体の値が JWT であることを検証し、構造的に有効な偽のトークンで置き換えます。サンドボックス内のコードがトークンをデコードし続けるようにします。プロキシは出力時に全体の実際のトークンを置き換えます。検証されない値は警告とともにマスクなしで渡されます。v2.1.224 以降が必要です |
| `maskClaims` | 文字列の配列。少なくとも 1 つのクレーム名。`decode` が必要 | デコードされた JWT 内の名前付きトップレベルペイロードクレームのみをマスクし、変更されたペイロードの周りにトークンを再構築します。他のクレームは読み取り可能なままです。名前付きクレームが一致しない場合、変数は警告とともにマスクなしで渡されます。v2.1.224 以降が必要です |
| `injectHosts` | 文字列の配列。各ホストは [`sandbox.network.allowedDomains`](#sandbox-network-alloweddomains) も認めます | サンドボックスプロキシが実際の値を置き換えるホストを絞ります。未設定の場合、プロキシは `sandbox.network.allowedDomains` のすべてのホストへのリクエストで置き換えます。IPv6 宛先を裸の圧縮アドレスとして書き込みます。例えば、`"::1"`。括弧形式ではなく。[`injectHosts` の IPv6 宛先](/docs/ja/sandboxing#ipv6-destinations-in-injecthosts)を参照してください |

これにより、`DATABASE_URL` 内のパスワードのみがマスクされ、パターンが何も一致しない場合は変数がアンセットされ、`SERVICE_JWT` の JWT がマスクされます。`api_key` を除くすべてのクレームは読み取り可能なままです：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "envVars": [
        {
          "name": "DATABASE_URL",
          "mode": "mask",
          "extract": "://[^:]+:([^@]+)@",
          "onExtractNoMatch": "deny"
        },
        {
          "name": "SERVICE_JWT",
          "mode": "mask",
          "decode": "jwt",
          "maskClaims": ["api_key"]
        }
      ]
    }
  }
}
```

<h3 id="sandbox-credentials-allowplaintextinject">
  `sandbox.credentials.allowPlaintextInject`
</h3>

TLS 終了 HTTPS だけでなく、プレーン HTTP リクエストでも `mask` 置換を許可します。プレーン HTTP では、アップストリーム ID は検証されず、認証情報はクリアテキストで移動するため、信頼できるテストネットワーク外ではこれをオフのままにします。

* **Scope**: [`User or managed`](#scopes)
* **Type**: ブール値
  * `true`: Claude Code はプレーン HTTP リクエストと TLS 終了 HTTPS の両方で `mask` 置換を許可します
  * `false`: Claude Code は TLS 終了 HTTPS でのみ `mask` 置換を許可します
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "allowPlaintextInject": true
    }
  }
}
```

<h3 id="sandbox-credentials-awspairs">
  `sandbox.credentials.awsPairs`
</h3>

マスクされた環境変数をグループ化して、認証情報が非標準の名前の変数に存在する場合、[SigV4 再署名](/docs/ja/sandboxing#re-sign-aws-requests)用に 1 つの AWS 認証情報を形成します。Claude Code は、従来の `AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`、`AWS_SESSION_TOKEN` トリオを全体の値をマスクする場合、自動的にリンクするため、他の名前の場合にのみこのキーが必要です。Claude Code v2.1.224 以降が必要です。

* **Scope**: [`User or managed`](#scopes)
* **Type**: オブジェクトの配列。各オブジェクトは `accessKeyIdVar`、`secretAccessKeyVar`、および optional `sessionTokenVar` を含み、`sandbox.credentials.envVars` エントリに名前を付けます
* **Default**: 未設定。従来のトリオのみがペアになります

これにより、3 つのカスタム名の変数が 1 つの AWS 認証情報にリンクされ、再署名されます：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "awsPairs": [
        {
          "accessKeyIdVar": "MY_KEY_ID",
          "secretAccessKeyVar": "MY_SECRET_KEY",
          "sessionTokenVar": "MY_SESSION_TOKEN"
        }
      ]
    }
  }
}
```

各名前付き変数は [`sandbox.credentials.envVars`](#sandbox-credentials-envvars) の全体値 `mask` エントリである必要があり、`extract` または `decode` なしで、すべてのペアで 1 つのスロットのみを埋めることができます。以下のルールも適用されます：

* プロキシは、アクセスキー ID エントリの `injectHosts` にリストされたホストでリクエストを再署名します
* `sessionTokenVar` が設定されている場合、プロキシは再署名されたリクエストで実際のトークンを `x-amz-security-token` として送信します
* ペアで従来の変数のいずれかを指定すると、自動ペアリングが置き換えられます

<h3 id="sandbox-credentials-sigv4">
  `sandbox.credentials.sigv4`
</h3>

サンドボックスプロキシが [再署名できない](/docs/ja/sandboxing#re-sign-aws-requests)AWS リクエスト形式で何をするかを選択します：`streaming` は aws-chunked ストリーミングアップロード、`presigned` は事前署名 URL、`sigv4a` は SigV4A 非対称署名です。これは、マスクされたペアのプレースホルダーアクセスキー ID で署名されたリクエストにのみ適用されます。Claude Code v2.1.224 以降が必要です。

* **Scope**: [`User or managed`](#scopes)
* **Type**: `streaming`、`presigned`、`sigv4a` を含むオブジェクト。各オブジェクトは以下のいずれかです：
  * `"deny"`: プロキシはリクエストを失敗させます
  * `"passthrough"`: プロキシはマスクされたプレースホルダーで署名されたリクエストを転送するため、ツールは AWS 自体の拒否を受け取ります
* **Default**: 未設定。すべての形式は `"deny"` です

これにより、ストリーミングアップロードはプロキシで失敗する代わりに転送されます：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "sigv4": {
        "streaming": "passthrough"
      }
    }
  }
}
```

`deny` の場合、プロキシはリクエストを失敗させます。`passthrough` の場合、プロキシはマスクされたプレースホルダーから計算された署名でリクエストを転送するため、AWS はそれを拒否し、呼び出しツールはプロキシエラーの代わりに AWS 自体のレスポンスを受け取ります。

<h3 id="sandbox-network">
  `sandbox.network`
</h3>

サンドボックス化されたコマンドが到達できるホスト、ポート、ソケットを制御します。サンドボックスは送信トラフィックをプロキシを通じてルーティングし、これらのリストを強制します。[ネットワーク分離](/docs/ja/sandboxing#network-isolation)を参照して、プロキシがどのように決定するか、およびいつプロンプトするかを確認してください。

* **Scope**: [`Any file`](#scopes)。`strictAllowlist`、`allowManagedDomainsOnly`、`tlsTerminate` は、それらのエントリが言うように、より少ないソースから読み取られます。
* **Type**: 以下のサブキーを含むオブジェクト
* **Default**: 未設定。ドメインは事前に許可されず、[新しい各ホストをどう扱うか](/docs/ja/sandboxing#hosts-outside-your-allowed-domains)は権限モードによって決まります

これにより、GitHub と npm が事前に許可され、`uploads.github.com` がブロックされ、コマンドが localhost にバインドできます：

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"],
      "deniedDomains": ["uploads.github.com"],
      "allowLocalBinding": true
    }
  }
}
```

Claude Code は配列サブキーを設定スコープ全体でマージするため、[リポジトリロック](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)が適用されない限り、プロジェクトはユーザーリストにドメインを追加できます。`WebFetch(domain:...)` 許可および拒否[権限ルール](/docs/ja/sandboxing#permission-rules)は同じ許可および拒否リストをフィードします。

<h3 id="sandbox-network-allowunixsockets">
  `sandbox.network.allowUnixSockets`
</h3>

macOS でサンドボックス化されたコマンドが接続できる Unix ソケットパスをリストします。Claude Code は Linux と WSL2 でこのリストを無視します。seccomp フィルタはソケットパスを検査できません。代わりに [`allowAllUnixSockets`](#sandbox-network-allowallunixsockets) を使用します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: 文字列の配列。各ソケットパス
* **Default**: 未設定。macOS サンドボックスはすべての Unix ソケットをブロックします

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowUnixSockets": ["~/.ssh/agent-socket"]
    }
  }
}
```

ソケットパスは広いアクセスを許可できます。たとえば、`/var/run/docker.sock` を許可すると、サンドボックス化されたコマンドが Docker デーモンを制御できます。[セキュリティ制限](/docs/ja/sandboxing#security-limitations)を参照してください。

<h3 id="sandbox-network-allowallunixsockets">
  `sandbox.network.allowAllUnixSockets`
</h3>

サンドボックス化されたコマンドがすべての Unix ソケットに接続できるようにします。Linux と WSL2 では、サンドボックスの [seccomp フィルタ](/docs/ja/sandboxing#set-up-linux-and-wsl2) は `socket(AF_UNIX, ...)` 呼び出しをブロックするため、これは Unix ソケットを許可する唯一の方法です。フィルタが不足している場合（`/sandbox` がその Dependencies タブで報告する場合）、サンドボックスは Unix ソケット呼び出しをブロックしません。[Linux と WSL2 をセットアップする](/docs/ja/sandboxing#set-up-linux-and-wsl2)を参照して、フィルタがどこから来るかを確認してください。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: ブール値
  * `true`: サンドボックス化されたコマンドはすべての Unix ソケットに接続できます
  * `false`: サンドボックスは Unix ソケット接続をブロックします：macOS では `allowUnixSockets` のパスを除き、Linux と WSL2 ではフィルタが存在する場合は seccomp フィルタを通じて
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowAllUnixSockets": true
    }
  }
}
```

WSL2 では、`true` は `cmd.exe` や `powershell.exe` などの Windows バイナリを起動する相互運用ソケットも再度開きます。

<h3 id="sandbox-network-allowlocalbinding">
  `sandbox.network.allowLocalBinding`
</h3>

macOS でサンドボックス化されたコマンドがネットワークポートでリッスンし（開発サーバーの起動など）、localhost の任意のポートに接続できるようにします。ループバック以外のアドレスでリッスンするコマンドは、他のマシンからの接続を受け付けます。Linux と WSL2 では各サンドボックス化されたコマンドが独自のループバックインターフェースを持つため、このキーは効果がありません。Linux または WSL2 からホスト上のサーバーに到達するには、[コマンドが localhost 上のサーバーに到達できない](/docs/ja/sandboxing#a-command-fails-to-reach-a-server-on-localhost)を参照してください。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: ブール値
  * `true`: macOS でサンドボックス化されたコマンドは任意のローカルアドレスでリッスンし、localhost の任意のポートに接続できます
  * `false`: macOS でサンドボックス化されたコマンドはポートでリッスンすることも、localhost 上のサーバーに直接接続することもできません
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowLocalBinding": true
    }
  }
}
```

<h3 id="sandbox-network-allowmachlookup">
  `sandbox.network.allowMachLookup`
</h3>

macOS サンドボックスが検索できる追加の XPC および Mach サービス名をリストします。iOS Simulator や Playwright などの XPC を通じて通信するツールは、ここにサービスをリストする必要があります。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: 文字列の配列。各サービス名。単一の末尾 `*` はプレフィックスと一致し、`"*"` だけはすべてのサービスと一致します
* **Default**: 未設定

これにより、`com.apple.coresimulator.` プレフィックスの下のすべてのサービスが許可されます：

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowMachLookup": ["com.apple.coresimulator.*"]
    }
  }
}
```

<h3 id="sandbox-network-alloweddomains">
  `sandbox.network.allowedDomains`
</h3>

サンドボックス化されたコマンドからの送信トラフィック用にドメインを事前に許可するため、サンドボックスはそれらについてプロンプトしません。`*.example.com` などのワイルドカードはサブドメインと一致し、optional `:port` サフィックスはエントリを 1 つのポートに制限します。ポートなしのエントリはすべてのポートと一致します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）。[`allowManagedDomainsOnly`](#sandbox-network-allowmanageddomainsonly)が設定されている場合、管理設定のみ。
* **Type**: 文字列の配列。各ドメイン、ワイルドカードパターン、または IP リテラル。optional `:port` サフィックス付き
* **Default**: 未設定。[新しい各ホストをどう扱うか](/docs/ja/sandboxing#hosts-outside-your-allowed-domains)は権限モードによって決まります

これにより、GitHub がすべてのポートで事前に許可され、すべての npm サブドメイン、および 1 つの API ホストがポート 443 でのみ許可されます：

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org", "api.example.com:443"]
    }
  }
}
```

IPv6 リテラルを括弧で囲んで書き込みます。optional ポート付き：`"[::1]"` はすべてのポートを許可し、`"[::1]:443"` は 1 つのポートを許可します。括弧形式には Claude Code v2.1.229 以降が必要です。[ドメインリストの IPv6 アドレス](/docs/ja/sandboxing#ipv6-addresses-in-domain-lists)を参照してください。

<h3 id="sandbox-network-denieddomains">
  `sandbox.network.deniedDomains`
</h3>

[`allowedDomains`](#sandbox-network-alloweddomains)と同じワイルドカード、ポート、IPv6 構文を使用して、サンドボックス化されたコマンドからの送信トラフィック用にドメインをブロックします。拒否されたドメインは、`allowedDomains` エントリも一致する場合でもブロックされたままです。

* **Scope**: [`Any file`](#scopes)
* **Type**: 文字列の配列。各ドメイン、ワイルドカードパターン、または IP リテラル。optional `:port` サフィックス付き
* **Default**: 未設定

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "deniedDomains": ["sensitive.cloud.example.com"]
    }
  }
}
```

Claude Code はセッションが読み込むすべての設定ソースからこのリストをマージします。`allowManagedDomainsOnly` が設定されている場合でも、開発者は常に拒否リストを厳しくできます。IPv6 リテラルについては、[ドメインリストの IPv6 アドレス](/docs/ja/sandboxing#ipv6-addresses-in-domain-lists)を参照してください。

完全修飾ドメイン名をマークする末尾ドット（`example.com.` など）で書き込まれたエントリは、`example.com` と同じ接続をブロックします。

<h3 id="sandbox-network-strictallowlist">
  `sandbox.network.strictAllowlist`
</h3>

許可リスト外のホストへのサンドボックス化されたコマンドのアクセスを、承認を求めるプロンプトを表示する代わりに拒否します。許可リストは [`allowedDomains`](#sandbox-network-alloweddomains) と `WebFetch(domain:...)` 許可ルールからのドメイン、または [`allowManagedDomainsOnly`](#sandbox-network-allowmanageddomainsonly) が設定されている場合は管理設定エントリのみです。リポジトリのエントリについては、[管理者必須のサンドボックスなしで適用されるロック](/docs/ja/sandboxing#locks-that-apply-without-an-admin-required-sandbox)を参照してください。Claude Code v2.1.219 以降が必要です。

* **Scope**: [`User or managed`](#scopes)。リポジトリはそれをオンまたはオフにできません。
* **Type**: ブール値
  * `true`: Claude Code は許可リスト外のホストへのサンドボックス化されたコマンドアクセスを拒否します
  * `false`: 別の信頼できる設定ファイルが `true` を設定しない限り、Claude Code は許可リスト外のホストを即座に拒否するのではなく、権限モードに応じて判断します：auto モードではコマンドの[コマンドごとの許可ドメイン](/docs/ja/sandboxing#per-command-allowed-domains-in-auto-mode)に対してホストをチェックし、`dontAsk` モードでは拒否し、`bypassPermissions` モードおよびバイパスが利用可能なインタラクティブターミナルの plan モードセッションでは許可し、それ以外の場合はユーザーに確認します
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "strictAllowlist": true
    }
  }
}
```

Claude Code はサンドボックス化されたコマンドのみに対してこれを強制します。`WebFetch` などのインプロセスツールは引き続き[権限ルール](/docs/ja/sandboxing#permission-rules)に従います。尊重されるソースのいずれかが `true` に設定する場合、それはオンのままです。[ネットワーク分離](/docs/ja/sandboxing#network-isolation)を参照してください。Claude Code v2.1.219 以降が必要です。

<h3 id="sandbox-network-allowmanageddomainsonly">
  `sandbox.network.allowManagedDomainsOnly`
</h3>

ネットワーク許可リストを管理設定が定義するものにロックします。Claude Code は管理設定からの `allowedDomains` と `WebFetch(domain:...)` 許可ルールのみを尊重し、ユーザー、プロジェクト、ローカル、`--settings` 設定からのドメインを無視し、許可されていないドメインをプロンプトする代わりに自動的にブロックします。

* **Scope**: [`Managed`](#scopes)
* **Type**: ブール値
  * `true`: Claude Code は管理設定からの `allowedDomains` と `WebFetch(domain:...)` 許可ルールのみを尊重し、許可されていないドメインをプロンプトする代わりにブロックします
  * `false`: 他の設定ファイルからのドメインも許可リストにマージされます
* **Default**: `false`

これにより、許可リストが GitHub と npm にロックされ、開発者が追加するドメインが無視されます：

```json managed-settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowManagedDomainsOnly": true,
      "allowedDomains": ["github.com", "*.npmjs.org"]
    }
  }
}
```

キーが `true` の間、サンドボックスは[管理者必須](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)となり、[プロキシポート](#sandbox-network-httpproxyport)を設定できるのは管理設定のみになります。

拒否されたドメインは引き続きセッションが読み込むすべてのソースからマージされます。[ポリシーの拡大を開発者に防止させる](/docs/ja/sandboxing#keep-developers-from-widening-the-policy)を参照してください。

<h3 id="sandbox-network-httpproxyport">
  `sandbox.network.httpProxyPort`
</h3>

Claude Code が実行するものの代わりに、独自の HTTP プロキシをサンドボックスに指定します。組織はこれを使用して、HTTPS トラフィックを検査したり、独自のフィルタリングルールを適用したり、リクエストをログに記録したりします。フィルタリングは独自のプロキシが引き継ぎ、Claude Code はそこに送信されるトラフィックにドメインリストとネットワークプロンプトを適用しなくなります。未設定の場合、Claude Code は HTTP トラフィック用に独自のプロキシを起動します。

* **Scope**: [`Any file`](#scopes)。ただし、[他のサンドボックス設定によってポートを設定できるファイルが制限される](/docs/ja/sandboxing#custom-proxy-configuration)場合を除きます
* **Type**: 数値。ローカル TCP ポート
* **Default**: 未設定。Claude Code は独自のプロキシを実行します

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "httpProxyPort": 8080
    }
  }
}
```

プロキシで SOCKS トラフィックも扱う場合は、[`socksProxyPort`](#sandbox-network-socksproxyport) も設定します。2 つのうち一方のみを設定した場合、Claude Code はもう一方のプロトコル用に引き続き独自のプロキシを実行します。[カスタムプロキシ設定](/docs/ja/sandboxing#custom-proxy-configuration)を参照してください。

<h3 id="sandbox-network-socksproxyport">
  `sandbox.network.socksProxyPort`
</h3>

Claude Code が実行するものの代わりに、独自の SOCKS5 プロキシをサンドボックスに指定します。フィルタリングは独自のプロキシが引き継ぎ、Claude Code はそこに送信されるトラフィックにドメインリストとネットワークプロンプトを適用しなくなります。未設定の場合、Claude Code は SOCKS トラフィック用に独自のプロキシを起動します。

* **Scope**: [`Any file`](#scopes)。ただし、[他のサンドボックス設定によってポートを設定できるファイルが制限される](/docs/ja/sandboxing#custom-proxy-configuration)場合を除きます
* **Type**: 数値。ローカル TCP ポート
* **Default**: 未設定。Claude Code は独自のプロキシを実行します

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "socksProxyPort": 8081
    }
  }
}
```

[カスタムプロキシ設定](/docs/ja/sandboxing#custom-proxy-configuration)を参照してください。

<h3 id="sandbox-network-tlsterminate">
  `sandbox.network.tlsTerminate`
</h3>

サンドボックスプロキシが TLS を終了して、HTTPS リクエストの内容を読み取ることができるようにします。これは実験的であり、`mask` [認証情報置換](/docs/ja/sandboxing#mask-credentials)はそれを必要とします。`{}` を設定してセッション用に一時的な認証局を生成するか、`caCertPath` と `caKeyPath` を設定して独自のものを使用します。

* **Scope**: [`User or managed`](#scopes)。リポジトリはそれをオンにするか、認証局を提供できません。
* **Type**: optional `caCertPath` と `caKeyPath` 文字列を含むオブジェクト。各ファイルパス
* **Default**: 未設定。プロキシは TLS を終了または検査しません

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "tlsTerminate": {}
    }
  }
}
```

複数の尊重されるソースがそれを設定する場合、Claude Code は最も優先度の高いソースからの値を使用します：管理設定、次に `--settings` フラグ、次にユーザー設定。

<span id="context-and-memory" />

<h2 id="memory-and-context">
  メモリとコンテキスト
</h2>

Claude Code がコンテキストに読み込む内容、コンパクト化の方法、メモリと計画の保存場所を制御します。[コンテキストの管理](/docs/ja/context-window)と[メモリ](/docs/ja/memory)を参照してください。

<h3 id="autocompactenabled">
  `autoCompactEnabled`
</h3>

コンテキストが制限に近づいたときに Claude Code が[会話を自動的にコンパクト化](/docs/ja/context-window#when-your-context-fills-up)するようにします。`/config` に**自動コンパクト化**として表示され、そこで切り替えるとこのキーがユーザー設定に書き込まれます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: コンテキストが制限に近づいたときに Claude Code が会話を自動的にコンパクト化します
  * `false`: Claude Code は自動的にコンパクト化しません
* **デフォルト**: `true`
* **セッションごとのオーバーライド**: [`DISABLE_AUTO_COMPACT`](/docs/ja/env-vars)は 1 つのセッションの自動コンパクト化をオフにします。2 つのうちどちらかがオフにすると、もう一方はオンに戻すことができません

```json settings.json theme={null}
{
  "autoCompactEnabled": false
}
```

手動の `/compact` コマンドは自動コンパクト化がオフの間も機能し続けます。

<h3 id="autocompactwindow">
  `autoCompactWindow`
</h3>

Claude Code が[自動的にコンパクト化](/docs/ja/context-window#when-your-context-fills-up)する前にコンテキストウィンドウがどの程度満杯になるかを設定します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: `100000` から `1000000` のトークン数。Claude Code はこの値をモデルのコンテキストウィンドウで上限に設定します。[モデル概要](https://platform.claude.com/docs/en/about-claude/models/overview)に各モデルのウィンドウが記載されています
* **デフォルト**: 未設定。Claude Code はモデルに合わせてチューニングされたウィンドウを選択します
* **セッションごとのオーバーライド**: [`--autocompact`](/docs/ja/cli-reference#cli-flags)は 1 つのセッションでこのキーより優先され、[`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](/docs/ja/env-vars)は両方より優先されます

```json settings.json theme={null}
{
  "autoCompactWindow": 500000
}
```

[`/autocompact`](/docs/ja/commands#all-commands) コマンドは、現在のモデルのウィンドウを [`modelSettings`](#modelsettings) の下に保存します。これは、そのモデルについて同じファイル内のこのキーより優先されます。[自動圧縮ウィンドウを設定](/docs/ja/model-config#set-the-auto-compact-window)では、コマンド、フラグ、変数、設定がどのように相互作用するかについて説明しています。

<h3 id="automemorydirectory">
  `autoMemoryDirectory`
</h3>

[自動メモリ](/docs/ja/memory#storage-location)をプロジェクトごとのデフォルトではなく、選択したディレクトリに保存します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列。絶対パスまたは `~/` で始まるディレクトリパス
* **デフォルト**: 未設定。Claude Code は `~/.claude/projects/<project>/memory/` を使用します

```json settings.json theme={null}
{
  "autoMemoryDirectory": "~/my-memory-dir"
}
```

プロジェクトまたはローカル設定から、Claude Code はこのキーを[フックと同じワークスペーストラストルール](/docs/ja/permissions#what-runs-before-you-trust-a-folder)の下で尊重します。クローンされたリポジトリはこれらのファイルを提供できるためです。

<h3 id="automemoryenabled">
  `autoMemoryEnabled`
</h3>

[自動メモリ](/docs/ja/memory#enable-or-disable-auto-memory)をオンまたはオフにします。`false` の場合、Claude は自動メモリディレクトリから読み取ったり書き込んだりしません。セッション中に `/memory` で切り替えることもできます。これはこのキーをユーザー設定に書き込みます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: 未設定と同じです。`--bare`、セーフモード、`CLAUDE_CODE_DISABLE_AUTO_MEMORY` など、セッションでこのキーより優先される何かがオフにしない限り、自動メモリはオンのままです
  * `false`: Claude は自動メモリディレクトリから読み取ったり書き込んだりしません
* **デフォルト**: `true`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_DISABLE_AUTO_MEMORY`](/docs/ja/env-vars)は 1 つのセッションでこのキーより優先されます。どちらの方向でも優先されます

```json settings.json theme={null}
{
  "autoMemoryEnabled": false
}
```

<h3 id="bashoutputmaxchars">
  `bashOutputMaxChars`
</h3>

成功した Bash または PowerShell コマンドの[出力 Claude が受け取るインライン](/docs/ja/tools-reference#output-limits)の文字数を設定します。出力が制限を超える場合、Claude Code はそれをファイルに保存し、Claude は短いプレビューとファイルのパスを受け取ります。詳細なビルドまたは完全なテストスイートログなどのコマンド出力がデフォルトを定期的に超過し、Claude がファイルを開かずに読み取ることを希望する場合は、制限を引き上げます。Claude Code v2.1.261 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字数。正の整数。Claude Code はこの値を `4000` から `128000` の範囲に制限します
* **デフォルト**: 未設定。Claude は最大 30,000 文字をインラインで受け取ります

```json settings.json theme={null}
{
  "bashOutputMaxChars": 100000
}
```

このキーを設定すると、Claude Code は[`BASH_MAX_OUTPUT_LENGTH`](/docs/ja/env-vars)環境変数を無視します。

<h3 id="claudemd">
  `claudeMd`
</h3>

CLAUDE.md スタイルの指示を別のファイルをデプロイせずに組織管理メモリとして挿入します。Claude Code はテキストをユーザーおよびプロジェクト CLAUDE.md ファイルの前に管理メモリエントリとして読み込みます。

* **スコープ**: [`管理`](#scopes)
* **タイプ**: 文字列。CLAUDE.md ファイルのテキスト。ファイルのように記述します。Markdown を含め、改行は `\n` として記述します
* **デフォルト**: 未設定

この例は 2 つのルールを短い Markdown リストとしてデプロイします。

```json managed-settings.json theme={null}
{
  "claudeMd": "# Engineering rules\n\n- Always run make lint before committing.\n- Never push directly to main."
}
```

[組織全体の CLAUDE.md をデプロイ](/docs/ja/memory#deploy-organization-wide-claude-md)を参照してください。

<h3 id="claudemdexcludes">
  `claudeMdExcludes`
</h3>

Claude Code が[メモリ](/docs/ja/memory#exclude-specific-claude-md-files)を読み込むときに特定の `CLAUDE.md` ファイルをスキップします。大規模なモノレポでは、これを使用して、作業に関連のない他のチームの CLAUDE.md ファイルをスキップします。[大規模コードベースガイド](/docs/ja/large-codebases#exclude-irrelevant-claude-md-files)の関連のない CLAUDE.md ファイルを除外するセクションでそのケースについて説明しています。パターンは絶対ファイルパスと照合されます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列の配列。各要素はグロブパターンまたは絶対パス
* **デフォルト**: 未設定。Claude Code は見つかったすべての CLAUDE.md を読み込みます

```json settings.json theme={null}
{
  "claudeMdExcludes": ["**/vendor/**/CLAUDE.md"]
}
```

除外はユーザー、プロジェクト、ローカルメモリファイルにのみ適用されます。管理ポリシー CLAUDE.md ファイルは除外できません。

<span id="environment-variables" />

<h3 id="env">
  `env`
</h3>

すべてのセッションと Claude Code がそこから開始するサブプロセスの環境変数を設定します。[環境変数リファレンス](/docs/ja/env-vars)の任意の変数をここに配置できます。これは 1 つをすべてのセッションに適用するか、チーム全体にロールアウトする方法です。プロジェクトおよびローカル設定は[それらの一部を設定できません](#variables-claude-code-ignores-in-env)。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 変数名を文字列値にマップするオブジェクト
* **デフォルト**: 未設定

この例は自動コンパクト化をオフにし、API リクエストをプロキシ経由でルーティングします。

```json settings.json theme={null}
{
  "env": {
    "DISABLE_AUTO_COMPACT": "1",
    "ANTHROPIC_BASE_URL": "https://proxy.example.com"
  }
}
```

<h4 id="how-env-values-interact-with-your-shell">
  `env` 値がシェルとどのように相互作用するか
</h4>

* ここの値はシェルでエクスポートされた同じ変数を上書きします。複数の設定ファイルが変数を設定する場合、[最も優先度の高い](/docs/ja/settings#settings-precedence)ものが適用されます。[Claude Code が `env` で無視する変数](#variables-claude-code-ignores-in-env)はプロジェクトおよびローカル設定の例外をリストします。
* Claude Desktop アプリまたは[自己ホスト環境](/docs/ja/self-hosted-environments)ランナーがセッションを開始する場合、それが構築する起動環境が代わりに優先されます。Claude Code は、起動環境がすでに設定している変数について、設定ファイルからの `env` 値を無視します。[デバッグログ](/docs/ja/debug-your-config)は無視された各変数の名前を付けます。
* シェルエクスポートをキャンセルするには、変数を `""` に設定します。Claude Code は空の値をプロバイダー選択の未設定として扱い、サブプロセスは空の値を継承します。
* `NO_COLOR` と `FORCE_COLOR` をここで設定すると、サブプロセスにのみ到達します。Claude Code 自体のインターフェースカラーを変更するには、`claude` を起動する前にシェルで設定します。
* ここの値は設定ファイルのプレーンテキストであり、Claude Code が開始するすべてのサブプロセスに到達します。ローテーションする OTLP ベアラートークンの場合は[`otelHeadersHelper`](#otelheadershelper)を使用します。API 認証情報の場合は[`apiKeyHelper`](#apikeyhelper)を使用します。

<h4 id="when-claude-code-applies-env-values">
  Claude Code が `env` 値を適用するタイミング
</h4>

* ユーザー設定、`--settings`、管理設定から: 起動時、および実行中のセッションでマージされた `env` を変更する保存された変更がある場合。
* プロジェクトおよびローカル設定から: ワークスペースを信頼した後、または `-p` モード（信頼ダイアログを表示しない）での起動時、およびマージされた `env` を変更する保存された変更がある場合。
* Claude Code がモデル選択、タイムアウトと制限、機能トグルなどの安全として分類する変数: [プロジェクトおよびローカル設定が設定できない変数](#variables-claude-code-ignores-in-env)を除き、すべての設定ファイルから起動時。
* v2.1.246 以降で[`/cd`](/docs/ja/permissions#move-the-session-to-another-directory)でセッションを移動した後: 新しいディレクトリのプロジェクトおよびローカル `env` 値。前のディレクトリの上に。

<h4 id="variables-claude-code-ignores-in-env">
  Claude Code が `env` で無視する変数
</h4>

* プロジェクトおよびローカル設定は、チェックアウトされたリポジトリが制御すべきではない変数を設定できません。代わりにシェル、ユーザー設定、または管理設定で設定します。Claude Code は、テレメトリをオフにするいくつかの値を除いて各変数をドロップし、`claude --debug` で確認できる警告をログに記録します。これらには以下が含まれます。

  * Claude Code が独自のファイルを保存または書き込む場所を選択する変数: `CLAUDE_CONFIG_DIR`、`CLAUDE_CODE_TMPDIR`、および `HOME`、`TMPDIR`、`TMP`、`TEMP`、`XDG_*` ファミリーなどのオペレーティングシステムディレクトリ変数。
  * Claude Code が開始するプロセスのプログラムとマシン全体の設定を選択する Windows 変数。`SystemRoot`、`ComSpec`、`ProgramData`、`LOCALAPPDATA`、`PATHEXT`、`PSModulePath`、`ProgramFiles` ファミリーなど。
  * セッションコンテンツをエクスポートする変数: [`OTEL_LOG_RAW_API_BODIES`](/docs/ja/env-vars#variables) および詳細なベータトレーシングペア `ENABLE_BETA_TRACING_DETAILED` と `BETA_TRACING_ENDPOINT`。
  * テレメトリをオンにする、送信先を選択する、またはキャプチャするコンテンツを選択する [OpenTelemetry エクスポーター](/docs/ja/monitoring-usage)変数:

    * `CLAUDE_CODE_ENABLE_TELEMETRY`、および拡張テレメトリベータペア `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA` と `ENABLE_ENHANCED_TELEMETRY_BETA`
    * エクスポーターセレクター `OTEL_LOGS_EXPORTER`、`OTEL_METRICS_EXPORTER`、`OTEL_TRACES_EXPORTER`
    * コンテンツ変数 `OTEL_LOG_USER_PROMPTS`、`OTEL_LOG_ASSISTANT_RESPONSES`、`OTEL_LOG_TOOL_CONTENT`、`OTEL_LOG_TOOL_DETAILS`
    * 名前が `_ENDPOINT`、`_HEADERS`、`_PROTOCOL`、`_CERTIFICATE`、`_CLIENT_KEY`、`_INSECURE` で終わる `OTEL_EXPORTER_OTLP_*` 変数（汎用およびシグナルごとの形式）。`OTEL_EXPORTER_OTLP_ENDPOINT` や `OTEL_EXPORTER_OTLP_METRICS_HEADERS` など
    * `OTEL_EXPORTER_PROMETHEUS_HOST` と `OTEL_EXPORTER_PROMETHEUS_PORT`

    これらの値のみがプロジェクトおよびローカル設定から適用されます。何かをオフにするため: 3 つのエクスポーターセレクターの場合は `none`。`OTEL_LOG_USER_PROMPTS`、`OTEL_LOG_TOOL_CONTENT`、`OTEL_LOG_TOOL_DETAILS` の場合は `0` などのオフ値。そのような値はユーザー設定で同じ変数をオーバーライドしますが、環境で Claude Code を起動するもの、`--settings` ファイル、または管理設定は設定しません。

    プロジェクトまたはローカル設定ファイルがこのグループの変数を設定する場合、ローカルインタラクティブセッションは起動時に通知を表示します。`/status` または `claude doctor` を実行して、Claude Code が無視したものと、テレメトリをオフにしたものを確認します。両方とも名前をリストします。値は決してリストしません。`-p` を使用した非インタラクティブ実行または Agent SDK セッションは通知を表示しないため、アップグレード後にコレクターがデータを受け取り続けるかどうかを確認します。受け取らない場合は、ユーザー設定、管理設定、ジョブの環境、または `--settings` で渡すファイルで変数を設定します。

    プロジェクトおよびローカル設定でこのグループを無視するには Claude Code v2.1.282 以降が必要です。
  * Claude Code の起動またはシンク方法を変更する変数。`CLAUDE_CODE_PROCESS_WRAPPER`、`CLAUDE_CODE_SYNC_SKILLS`、`CLAUDE_CODE_SYNC_PLUGINS`、`CLAUDE_CODE_PLUGIN_CACHE_DIR`、`CLAUDE_CODE_PLUGIN_SEED_DIR` など。
  * 応答のないダイアログのタイマーを設定する変数: [`CLAUDE_CODE_USER_DIALOG_TIMEOUT_MS`、`CLAUDE_AFK_TIMEOUT_MS`、`CLAUDE_AFK_COUNTDOWN_MS`](/docs/ja/env-vars#variables)。
  * 添付ファイルの処理をオフにする [`CLAUDE_CODE_DISABLE_ATTACHMENTS`](/docs/ja/env-vars#variables)。

  v2.1.251 より前は、プロジェクトおよびローカル設定は `HOME` と `XDG_CONFIG_HOME` を除き、このリストのうち Claude Code がファイルを書き込む場所を選択する変数、またはセッションコンテンツをエクスポートする変数も設定できました。v2.1.290 より前は、ダイアログのタイマー変数と `CLAUDE_CODE_DISABLE_ATTACHMENTS` も設定できました。
* Claude Code のホスティング環境が所有する `CLAUDE_CODE_REMOTE` や `CLAUDE_CODE_ACCOUNT_UUID` などのアイデンティティ変数は、すべてのファイルから無視されます。
* [`CLAUDE_CODE_MESSAGING_SOCKET` と `CLAUDE_CODE_MESSAGING_TOKEN`](/docs/ja/env-vars#variables)。Claude Code 自体がエクスポートするものは、すべてのファイルから無視されます。ソケット変数を無視するには Claude Code v2.1.224 以降が必要で、トークンを無視するには v2.1.228 以降が必要です。
* [`CLAUDE_CODE_PROJECT_DIR_NAME`](/docs/ja/sessions#name-the-project-directory-yourself)。Claude Code は起動環境からのみ読み取ります。すべてのファイルから無視されます。v2.1.234 以降が必要です。
* [`CLAUDE_CODE_RESTRICTED`](/docs/ja/env-vars#variables)。Claude Code は起動環境からのみ読み取ります。すべてのファイルから無視されます。
* [`CLAUDE_CODE_DISABLE_POWERSHELL_CMD_RM_DENY`](/docs/ja/env-vars#variables)。Claude Code は起動環境からのみ読み取ります。すべてのファイルから無視されます。この変数には Claude Code v2.1.283 以降が必要です。
* [`CLAUDE_CODE_DISABLE_DANGEROUS_RM_TIMEOUT`、`CLAUDE_CODE_DISABLE_SUBSTITUTION_RM_PROMPT`、`CLAUDE_CODE_DISABLE_INLINE_SHELL_RM_PROMPT`](/docs/ja/env-vars#variables)。Claude Code は起動環境からのみ読み取ります。すべてのファイルから無視されます。

<h3 id="filecheckpointingenabled">
  `fileCheckpointingEnabled`
</h3>

各編集の前にファイルをスナップショットして、[`/rewind`](/docs/ja/checkpointing)がそれらを復元できるようにします。`/config` に\*\*コードを巻き戻す（チェックポイント）\*\*として表示され、そこで切り替えるとこのキーがユーザー設定に書き込まれます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は各編集の前にファイルをスナップショットして、`/rewind` がそれらを復元できるようにします
  * `false`: Claude Code はファイルをスナップショットしないため、`/rewind` はそれらを復元できません
* **デフォルト**: `true`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_DISABLE_FILE_CHECKPOINTING`](/docs/ja/env-vars)は 1 つのセッションのチェックポイント作成をオフにします。2 つのうちどちらかがオフにすると、もう一方はオンに戻すことができません

```json settings.json theme={null}
{
  "fileCheckpointingEnabled": false
}
```

`-p` 実行または Agent SDK セッションでは、Claude Code はこのキーを無視します。SDK は `enableFileCheckpointing` オプションでチェックポイント作成をオンにし、ベアの `-p` 実行には `CLAUDE_CODE_ENABLE_SDK_FILE_CHECKPOINTING=true` が必要です。[Agent SDK でのファイルチェックポイント作成](/docs/ja/agent-sdk/file-checkpointing)を参照してください。

<h3 id="plansdirectory">
  `plansDirectory`
</h3>

Claude Code が [plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)で書き込む計画ファイルを保存する場所を選択します。Claude Code はパスをプロジェクトルートを基準に解決します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列。プロジェクトルートを基準とした相対パス
* **デフォルト**: 未設定。Claude Code は `~/.claude/plans` を使用します

```json settings.json theme={null}
{
  "plansDirectory": "./plans"
}
```

次のような場合、Claude Code は設定したディレクトリではなく `~/.claude/plans` に計画を保存します。

* **プロジェクトルートの外側**: `"../plans"` のように、パスがプロジェクトルートの外側に解決される場合。
* **macOS、Linux、WSL でのバックスラッシュ**: Windows 形式の `"docs\\plans"` のように、解決されたパスにバックスラッシュが含まれる場合。Windows でも動作する `"docs/plans"` と記述してください。

<h3 id="skilllistingbudgetfraction">
  `skillListingBudgetFraction`
</h3>

各ターンで、Claude は[スキルのリスト](/docs/ja/skills#skill-descriptions-are-cut-short)とその説明を見ます。Claude Code はそのリスティングをコンテキストウィンドウのシェアで上限に設定します。リスティングが上限を超える場合、Claude Code はすべてのスキルの名前を保持しますが、最も使用されていないスキルの説明をドロップします。Claude はそれらのスキルを呼び出すことはできますが、独自に選択する可能性は低くなります。このキーを引き上げて、ターンごとにより多くのコンテキストを消費する代わりに、より多くの説明を表示させます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 数値。`0` より大きく、最大 `1` の分数
* **デフォルト**: `0.01`。コンテキストウィンドウの 1% を予約します

```json settings.json theme={null}
{
  "skillListingBudgetFraction": 0.02
}
```

リスティングがどの程度のコンテキストを使用し、どのスキルが最も貢献しているかを確認するには、`/doctor` を実行します。

<h3 id="skilllistingmaxdescchars">
  `skillListingMaxDescChars`
</h3>

各ターンで、Claude は[スキルのリスト](/docs/ja/skills#skill-descriptions-are-cut-short)を見ます。これは各スキルの `description` と `when_to_use` テキストを表示します。このキーは Claude Code がスキルごとに表示するそのテキストの文字数を上限に設定します。より長いテキストは上限で切り詰められます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字数。正の整数
* **デフォルト**: `1536`

```json settings.json theme={null}
{
  "skillListingMaxDescChars": 2048
}
```

ターンごとにより多くのコンテキストを消費する代わりに、長い説明を完全に保つために引き上げます。[`skillListingBudgetFraction`](#skilllistingbudgetfraction)の下により多くのスキルを適合させるために引き下げます。

<h3 id="taskoutputmaxchars">
  `taskOutputMaxChars`
</h3>

<Warning>
  v2.1.277 で削除されました。これとともに、それをサイズ設定した `TaskOutput` ツールも削除されました。現在のバージョンでこれを設定しても効果がありません。Claude は代わりに `Read` を使用して、バックグラウンドタスクの[出力ファイル](/docs/ja/tools-reference#background-commands)を読み取ります。
</Warning>

v2.1.276 を通じて、このキーを[バックグラウンドタスク](/docs/ja/tools-reference#background-commands)の出力の文字数に設定しました。Claude が `TaskOutput` ツールでタスクを読み取るときにインラインで受け取ります。

<h2 id="interface-and-terminal">
  インターフェースとターミナル
</h2>

Claude Code がターミナルでどのように見え、動作するかを変更します。テーマ、エディタモード、ステータスライン、スピナー、セッション内の通知、アクセシビリティなどです。[ターミナル設定](/docs/ja/terminal-config)を参照してください。

<h3 id="askuserquestiontimeout">
  `askUserQuestionTimeout`
</h3>

回答されていない [`AskUserQuestion`](/docs/ja/tools-reference) ダイアログがアイドル時間の経過後に自動的に続行し、既に選択していたオプションを送信するようにします。席を離れて Claude に続行させたい場合に設定します。デフォルトでは、質問は回答されるまで待機します。タイマーが一時停止する場合や開始されない場合については、[質問の自動続行タイムアウト](/docs/ja/tools-reference#question-auto-continue-timeout)を参照してください。

* **スコープ**: [`ユーザーまたはマネージド`](#scopes)
* **タイプ**: 文字列、`"60s"`、`"5m"`、`"10m"`、または `"never"` のいずれか
* **デフォルト**: `"never"`
* **セッションごとのオーバーライド**: [`CLAUDE_AFK_TIMEOUT_MS`](/docs/ja/env-vars) はこのキーより優先されます

```json settings.json theme={null}
{
  "askUserQuestionTimeout": "5m"
}
```

`/config` に**質問の自動続行タイムアウト**として表示され、このキーをユーザー設定に書き込みます。管理設定または `--settings` フラグがキーを設定している場合、Claude Code は行を非表示にします。

<h3 id="autocontinueatusagelimit">
  `autoContinueAtUsageLimit`
</h3>

claude.ai の使用制限がセッションを停止した後、開いているセッションで待機し、リセット後にタスクを自動的に続行します。[自動続行をオフにする](/docs/ja/interactive-mode#turn-automatic-continue-off)を参照してください。Claude Code v2.1.234 以降が必要です。

* **スコープ**: [`ユーザーまたはマネージド`](#scopes)。ユーザー設定、`--settings`、およびマネージド設定からのみ読み取ります。これらのいずれもキーを設定しない場合、プロジェクトまたはローカル設定ファイルがキーを設定すると、機能は無視されるのではなくオフになります。
* **タイプ**: ブール値
  * `true`: claude.ai の使用制限がセッションを停止した後、Claude Code は開いているセッションで待機し、リセット後にタスクを自動的に続行します
  * `false`: Claude Code は独自に待機を開始しません。[使用制限オプションメニューから自分で待機を開始](/docs/ja/interactive-mode#start-a-wait-yourself)できます
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "autoContinueAtUsageLimit": false
}
```

`/config` に**使用制限で自動的に続行**として表示され、このキーをユーザー設定に書き込みます。マネージド設定または `--settings` フラグがキーを設定している場合、Claude Code は行を非表示にします。

<h3 id="autoscrollenabled">
  `autoScrollEnabled`
</h3>

[フルスクリーンレンダリング](/docs/ja/fullscreen)で会話の下部に新しい出力を追従します。オフにすると、Claude が作業を続ける間、スクロールした場所に留まります。権限プロンプトは引き続き表示されます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: 会話は新しい出力の下部に追従します
  * `false`: Claude が作業を続ける間、スクロールした場所に留まります。権限プロンプトはトランスクリプトの下に表示されます
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "autoScrollEnabled": false
}
```

`/config` にフルスクリーンレンダリングがオンの場合**自動スクロール**として表示され、このキーをユーザー設定に書き込みます。

<h3 id="axscreenreader">
  `axScreenReader`
</h3>

スクリーンリーダーフレンドリーな出力をレンダリングします。装飾的なボーダーやアニメーションのないフラットテキストです。スクリーンリーダーモードはクラシックレンダラーを使用するため、アクティブな間は `tui` 設定は効果がありません。接続された[バックグラウンドセッション](/docs/ja/agent-view)は引き続きフルスクリーンでレンダリングされます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は装飾的なボーダーやアニメーションのないフラットテキストをレンダリングし、クラシックレンダラーを使用します
  * `false`: Claude Code は通常通りレンダリングします
* **デフォルト**: 未設定、スクリーンリーダーモードはオフです
* **セッションごとのオーバーライド**: [`--ax-screen-reader`](/docs/ja/cli-reference#cli-flags) は [`CLAUDE_AX_SCREEN_READER`](/docs/ja/env-vars) より優先され、両方ともこのキーより優先されます

```json settings.json theme={null}
{
  "axScreenReader": true
}
```

<h3 id="basheditdiffenabled">
  `bashEditDiffEnabled`
</h3>

Bash コマンドの実行中に Git リポジトリで変更されたファイルを Claude Code が記録するかどうかを選択します。記録する場合、コマンド後にターミナルでそれらの diff が表示され、[PostToolUse Bash フック](/docs/ja/hooks#bash)は変更されたファイルのリストを受け取ります。

リストされたファイルは常にコマンドが変更したものとは限りません。コマンドの実行中に別のプログラムまたは別の Bash 呼び出しが行った変更もそこに表示される可能性があります。

キーを `true` に設定して、すべての権限モードで記録します。Claude Code v2.1.269 以降が必要です。

* **スコープ**: [`ユーザーまたはマネージド`](#scopes)。`true` はユーザー設定、`--settings` で渡された JSON、または[マネージド設定](/docs/ja/managed-settings)からのみカウントされるため、リポジトリの `.claude/settings.json` または `.claude/settings.local.json` の `true` は記録をオンにできません。リポジトリファイルの `false` は[より高い優先度](/docs/ja/settings#settings-precedence)のファイルが `true` を設定しない限り、引き続きオフになります。
* **タイプ**: ブール値
* **デフォルト**: 未設定、Claude Code は自動モードと `bypassPermissions` モードで Claude が Bash を通じてファイルを編集するように指示する場合に変更を記録します
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_BASH_EDIT_DIFF`](/docs/ja/env-vars) はこのキーより優先されます

```json settings.json theme={null}
{
  "bashEditDiffEnabled": true
}
```

<h3 id="companyannouncements">
  `companyAnnouncements`
</h3>

スタートアップ時に組織のアナウンスメントをユーザーに表示します。複数をリストする場合、Claude Code は各セッションでランダムに 1 つを選択します。ユーザーの最初の起動時には最初のエントリが表示されます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列の配列
* **デフォルト**: 未設定、アナウンスメントは表示されません

```json settings.json theme={null}
{
  "companyAnnouncements": [
    "Welcome to Acme Corp! Review our code guidelines at docs.example.com"
  ]
}
```

<h3 id="defaultshell">
  `defaultShell`
</h3>

入力ボックスで[`!` プレフィックス](/docs/ja/interactive-mode#shell-mode-with-prefix)で入力したシェルコマンド、Claude Code が直接実行してセッションに追加するコマンドを実行するかどうかを選択します。Bash または PowerShell。

`"powershell"` は[PowerShell ツール](/docs/ja/tools-reference#powershell-tool)がオンの場合のみ機能します。このツールは Git Bash のない Windows ではデフォルトでオンであり、Git Bash を使用する Windows では claude.ai および Console アカウント用にオンです。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry セッション、および macOS、Linux、WSL では、`CLAUDE_CODE_USE_POWERSHELL_TOOL=1` を設定してツールをオンにします。そのツールをオフにするには、その変数を `0` に設定します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか:
  * `"bash"`: Claude Code は `!` コマンドを Bash で実行します
  * `"powershell"`: Claude Code は `!` コマンドを PowerShell で実行します
* **デフォルト**: `"bash"`、または Bash が利用できない Windows では `"powershell"`

```json settings.json theme={null}
{
  "defaultShell": "powershell"
}
```

指定したシェルが利用できない場合、Claude Code は他方を使用します。`"powershell"` は PowerShell ツールがオフの場合 Bash にフォールバックし、`"bash"` は Bash がインストールされていない場合 PowerShell にフォールバックします。

<h3 id="dialogexpiry">
  `dialogExpiry`
</h3>

Claude Code が[リモートクライアントに転送](/docs/ja/remote-control#limitations)するダイアログ（Remote Control または SDK ホストなど）および[保留中のクロスセッションメッセージ](/docs/ja/cross-session-messaging#control-inbound-messages)の承認ダイアログの期限を設定します。Claude Code v2.1.236 以降では、同じ期限が誰もターミナルにいない可能性があるセッションの途中の[Fable 使用クレジット同意プロンプト](/docs/ja/model-config#fable-and-usage-credits)を制限します。期限前に回答が到着しない場合、Claude Code はダイアログをキャンセルし、デフォルトのアクションなしで続行します。Claude Code v2.1.224 以降が必要です。

* **スコープ**: [`ユーザーまたはマネージド`](#scopes)
* **タイプ**: 文字列、`"60s"`、`"5m"`、`"10m"`、または期限を無効にする `"never"` のいずれか
* **デフォルト**: `"5m"`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_USER_DIALOG_TIMEOUT_MS`](/docs/ja/env-vars) はこのキーより優先されます

```json settings.json theme={null}
{
  "dialogExpiry": "10m"
}
```

権限プロンプトと[`AskUserQuestion`](/docs/ja/tools-reference#askuserquestion-tool-behavior)質問は独自のフローを使用し、この期限の対象ではありません。Claude Code v2.1.232 以降では `/config` に**ダイアログの有効期限**として表示され、このキーをユーザー設定に書き込みます。行には Claude Code v2.1.232 以降が必要であり、マネージド設定または `--settings` フラグがキーを設定している場合、Claude Code は行を非表示にします。

<h3 id="editormode">
  `editorMode`
</h3>

入力プロンプトのキーバインディングモードを選択します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか:
  * `"normal"`: プロンプト入力の標準キーバインディング
  * `"vim"`: NORMAL、INSERT、VISUAL モードを備えた vim スタイルの編集
* **デフォルト**: `"normal"`

```json settings.json theme={null}
{
  "editorMode": "vim"
}
```

`/config` に**エディタモード**として表示され、このキーをユーザー設定に書き込みます。

<h3 id="emojicompletionenabled">
  `emojiCompletionEnabled`
</h3>

プロンプト入力で `:` とショートコードを入力するときに絵文字の提案を表示し、`:heart:` などの完成したショートコードを絵文字に置き換えます。`false` に設定して両方をオフにします。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は `:` の後に絵文字の提案を表示し、完成したショートコードを絵文字に置き換えます
  * `false`: Claude Code は絵文字を提案せず、ショートコードを置き換えません
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "emojiCompletionEnabled": false
}
```

[絵文字ショートコード](/docs/ja/interactive-mode#emoji-shortcodes)を参照してください。Claude Code v2.1.217 以降が必要です。

<span id="file-suggestion-settings" />

<h3 id="filesuggestion">
  `fileSuggestion`
</h3>

組み込みのファイル提案の代わりに、`@` ファイルパスオートコンプリートを提供する独自のコマンドを実行します。組み込み提案は高速ファイルシステムトラバーサルを使用します。大規模なモノレポは事前構築されたファイルインデックスなどのプロジェクト固有のインデックスでより良い結果が得られる場合があります。

* **スコープ**: [`任意のファイル`](#scopes)。[ステータスラインとファイル提案ゲート](#status-line-and-file-suggestion-gates)の下では、Claude Code はコマンドをオフにするか、マネージド値のみを実行し、警告なしにあなたのコマンドをスキップします。
* **タイプ**: `type`（常に `"command"`）と `command`（実行するシェルコマンド）を持つオブジェクト
* **デフォルト**: 未設定、Claude Code は組み込みのファイル提案を使用します

```json settings.json theme={null}
{
  "fileSuggestion": {
    "type": "command",
    "command": "~/.claude/file-suggestion.sh"
  }
}
```

これを保存した後、プロンプトで `@` に続けてパスの一部を入力します。提案はコマンドの出力から取得されます。

<h4 id="command-input-and-output">
  コマンド入力と出力
</h4>

Claude Code は[フック](/docs/ja/hooks)と同じ環境変数（`CLAUDE_PROJECT_DIR` を含む）でコマンドを実行し、5 秒後に待機を停止します。コマンドは stdin で `query` フィールドを持つ JSON を受け取ります。これまでに入力したものを保持します:

```json theme={null}
{"query": "src/comp"}
```

stdout にニューラインで区切られたファイルパスを出力します。Claude Code は最大 15 個を表示します:

```text theme={null}
src/components/Button.tsx
src/components/Modal.tsx
src/components/Form.tsx
```

次のスクリプトはクエリを読み取り、リポジトリファイルインデックスに渡します:

```bash theme={null}
#!/bin/bash
query=$(cat | jq -r '.query')
# Replace your-repo-file-index with your own file search command
your-repo-file-index --query "$query" | head -20
```

<span id="footer-link-badges" />

<h3 id="footerlinksregexes">
  `footerLinksRegexes`
</h3>

ターン出力（ツール結果（ファイルコンテンツと取得されたページを含む）および Claude 自身の応答）に正規表現がマッチするときに、入力ボックスの下のフッターに追加のクリック可能なバッジをレンダリングします。プロジェクト CLI によって出力される ID（レビューツールおよび問題トラッカーなど）をセッションリンクに変換するために使用します。

* **スコープ**: [`ユーザーまたはマネージド`](#scopes)
* **タイプ**: オブジェクトの配列。各オブジェクトは `type` を `"regex"` に設定し、`pattern` 正規表現、`url` テンプレート、およびオプションの `label` を持ちます。`url` および `label` の `{name}` プレースホルダーは `pattern` の名前付きキャプチャグループから入力されます
* **デフォルト**: 未設定、バッジはレンダリングされません

この例は `PROJ-1234` などの問題キーにマッチし、キャプチャされたキーから各リンクを構築します:

```json settings.json theme={null}
{
  "footerLinksRegexes": [
    {
      "type": "regex",
      "pattern": "\\b(?<key>PROJ-\\d+)\\b",
      "url": "https://issues.example.com/browse/{key}",
      "label": "{key}"
    }
  ]
}
```

これが設定されている場合、`PROJ-1234` がツール結果または Claude の応答に表示されると、`PROJ-1234` バッジがフッターに表示され、`https://issues.example.com/browse/PROJ-1234` にリンクします。

<h4 id="badge-constraints">
  バッジの制約
</h4>

各エントリの URL、ラベル、およびバッジ数は次のように制限されます:

| 制約 | 動作 |
| :- | :- |
| URL オリジン | キャプチャされた値は URL エンコードされ、構築された URL はテンプレートのリテラルオリジンを共有する必要があります。キャプチャはパスセグメントまたはクエリ値を入力できますが、リンクが指す場所を変更することはできません |
| URL 長 | 2048 文字より長い構築された URL は削除されます |
| URL スキーム | `https`、`http`、または認識されたエディタまたはワークスペースディープリンクスキーム: `vscode`、`vscode-insiders`、`cursor`、`windsurf`、`zed`、`jetbrains`、`idea`、`slack`、`linear`、`notion`、`figma` である必要があります |
| ラベル | マッチしたテキストにデフォルト設定され、28 表示列に切り詰められます |
| バッジ数 | 最大 5 個のバッジがレンダリングされます。最も古いものは新しいマッチに置き換えられ、`/clear` はそれらを削除します |

ターンが完了すると、Claude Code はメインスレッドでターン出力に対して各エントリの `pattern` 正規表現をマッチングするため、遅い正規表現は完了するまで UI をブロックします。`(a+)+$` などのネストされた量指定子は特定の入力に対して指数関数的に長くかかり、セッションをフリーズさせる可能性があるため、各 `pattern` を線形に保ち、`+` または `*` のネストを避けてください。

フッターバッジは[カスタムステータスライン](/docs/ja/statusline)が設定されている場合と並んでレンダリングされます。どちらも他方を置き換えません。セッションデータから独自のコンテンツを計算するスクリプト駆動行にはステータスラインを使用し、会話から ID をリンクに変換するにはフッターバッジを使用します。

<h3 id="keybindingflavor">
  `keybindingFlavor`
</h3>

<Warning>
  v2.1.261 以降非推奨であり、効果がありません。プロンプトのワード編集キーは常に[readline 規約に従います](/docs/ja/interactive-mode#make-ctrl-w-delete-back-to-whitespace)。Bash のように。Claude Code は引き続き `keybindingFlavor` を受け入れるため、それを設定する設定ファイルは有効なままです。
</Warning>

v2.1.238 から v2.1.260 では、`"readline"` に設定すると `Ctrl+W` は前の単語だけでなく前の空白文字に戻って削除されました。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、`"classic"` または `"readline"`
* **デフォルト**: 未設定

<h3 id="maxprosewidth">
  `maxProseWidth`
</h3>

Claude の応答の散文の幅を制限して、行が広いターミナルで読みやすく保ちます。段落、見出し、リスト、およびブロック引用はこの多くの列内でラップされ、テーブルとコードブロックはターミナルの全幅を保ちます。Claude Code v2.1.282 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ターミナル列の数、整数、最小 `40`。Claude Code は他の値を無視します
* **デフォルト**: 未設定、散文はターミナルエッジでラップされます

```json settings.json theme={null}
{
  "maxProseWidth": 80
}
```

<h3 id="prefersreducedmotion">
  `prefersReducedMotion`
</h3>

スピナー、シマー、フラッシュエフェクトなどのインターフェースアニメーションを削減またはオフにします。`/config` に**モーションを削減**として表示されます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code はスピナー、シマー、フラッシュエフェクトなどのインターフェースアニメーションを削減またはオフにします
  * `false`: 未設定と同じです。Claude Code はアニメーションを表示します
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "prefersReducedMotion": true
}
```

<h3 id="promptsuggestionenabled">
  `promptSuggestionEnabled`
</h3>

[プロンプト提案](/docs/ja/interactive-mode#prompt-suggestions)を表示または非表示にします。プロンプト入力に表示される灰色の予測です。`false` に設定するか、`/config` で**プロンプト提案**をオフにして非表示にします。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: プロンプト入力にプロンプト提案が表示されます
  * `false`: Claude Code はプロンプト提案を非表示にします
* **デフォルト**: `true`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION`](/docs/ja/env-vars) はこのキーより優先されます

```json settings.json theme={null}
{
  "promptSuggestionEnabled": false
}
```

プロンプト提案には、テレメトリがオンの claude.ai または Console アカウントが必要です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または [`DISABLE_TELEMETRY`](/docs/ja/env-vars) によるテレメトリがオフの場合、このキーは効果がなく、`CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION=1` のみがそれらをオンにします。

<h3 id="respectgitignore">
  `respectGitignore`
</h3>

`@` ファイルピッカーが `.gitignore` パターンにマッチするファイルを除外するかどうかを制御します。`/config` に**ファイルピッカーで .gitignore を尊重**として表示されます。

* **スコープ**: [`任意のファイル`](#scopes)。設定ファイルがそれを設定しない場合、Claude Code は `~/.claude.json` の `respectGitignore` にフォールバックします。これは `/config` トグルが書き込みます。
* **タイプ**: ブール値
  * `true`: `@` ファイルピッカーは `.gitignore` パターンにマッチするファイルを除外します
  * `false`: `@` ファイルピッカーは `.gitignore` パターンにマッチするファイルを含めます
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "respectGitignore": false
}
```

<h3 id="respondtobashcommands">
  `respondToBashCommands`
</h3>

入力ボックスで[`!` プレフィックス](/docs/ja/interactive-mode#shell-mode-with-prefix)でシェルコマンドを実行した後、Claude が応答するかどうかを選択します。デフォルトでは、Claude Code はコマンドの出力を会話に追加し、Claude がそれに応答します。このキーを `false` に設定して、応答なしでコンテキストに出力を追加し、複数のコマンドを実行して一緒に質問できるようにします。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code はコマンドの出力を会話に追加し、Claude がそれに応答します
  * `false`: Claude Code は応答なしでコンテキストに出力を追加します
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "respondToBashCommands": false
}
```

[`!` プレフィックスでシェルモード](/docs/ja/interactive-mode#shell-mode-with-prefix)を参照してください。

<h3 id="showclearcontextonplanaccept">
  `showClearContextOnPlanAccept`
</h3>

Claude が[プランモード](/docs/ja/permission-modes#review-and-approve-a-plan)でプランを完了すると、承認メニューが表示されます。計画は多くのコンテキストを使用できるため、このキーはそのメニューに最初のオプション**はい、コンテキストをクリアして…** を追加します。これはプランを承認し、会話コンテキストをクリアし、プランだけから実装を開始します。ラベルの残りはセッションが続く権限モードに名前を付け、計画がコンテキストをどの程度使用したかを示します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: プラン承認メニューは最初のオプション**はい、コンテキストをクリアして…** を取得します。これはプランを承認し、会話コンテキストをクリアします
  * `false`: プラン承認メニューはクリアコンテキストオプションを表示しません
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "showClearContextOnPlanAccept": true
}
```

<h3 id="showturnduration">
  `showTurnDuration`
</h3>

各応答後のターン期間メッセージを表示または非表示にします。例えば「Cooked for 1m 6s · done 6:05 PM」。「done」の後の時計はターンが完了した時刻を示します。[`timeFormat`](#timeformat) と [`timeZone`](#timezone) はその形式とゾーンを制御します。`/config` に**ターン期間を表示**として表示されます。

* **スコープ**: [`任意のファイル`](#scopes)。古いバージョンの `~/.claude.json` の値は、設定ファイルがそれを設定しない場合に適用されます。
* **タイプ**: ブール値
  * `true`: 各応答後にターン期間メッセージが表示されます
  * `false`: Claude Code はターン期間メッセージを非表示にします
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "showTurnDuration": false
}
```

<h3 id="spellcheck">
  `spellcheck`
</h3>

入力時にプロンプト入力でスペルミスのある単語に下線を引きます。インストールするスペルチェッカーを使用します。Claude Code はプロンプト入力ボックスのテキストのみをチェックします。[入力時にスペルをチェック](/docs/ja/interactive-mode#check-spelling-as-you-type)は aspell、hunspell、または ispell のインストールとチェッカーがカバーするものについて説明しています。Claude Code v2.1.235 以降が必要です。

* **スコープ**: [`ユーザーまたはマネージド`](#scopes)。それを設定する最高層のブロックが全体として適用されます。
* **タイプ**: `enabled`（ブール値）、`checker`（`"aspell"`、`"hunspell"`、`"ispell"`、または `"auto"`）、`language`（文字列、チェッカーの辞書名として渡される）、および `color`（文字列、ターミナルカラー名、`#rrggbb`、`rgb(r,g,b)`、`ansi256(n)`、または `ansi:<name>`）を持つオブジェクト
* **デフォルト**: 未設定、スペルチェックはオフです。`checker` はデフォルトで `"auto"`、`PATH` で見つかった最初の 3 つです。`language` はデフォルトでチェッカー自身の辞書です。`color` はデフォルトでテーマのエラーカラーです

```json settings.json theme={null}
{
  "spellcheck": { "enabled": true, "language": "en_GB" }
}
```

<h3 id="spinnertipsenabled">
  `spinnerTipsEnabled`
</h3>

Claude が作業している間、スピナーラインは「Plan Mode を使用して複雑なリクエストに備えてから変更を加えます。Shift+Tab を 2 回押して有効にします」などの Claude Code 機能に関する短いヒントをローテーションします。このキーを `false` に設定して非表示にします。`/config` に**ヒントを表示**として表示されます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude が作業している間、スピナーにヒントが表示されます
  * `false`: Claude Code はスピナーヒントを非表示にします
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "spinnerTipsEnabled": false
}
```

<h3 id="spinnertipsoverride">
  `spinnerTipsOverride`
</h3>

Claude Code が Claude の作業中に表示する[スピナーヒント](#spinnertipsenabled)に独自のヒントを追加するか、組み込みヒントを置き換えます。Claude Code はあなたのヒントを組み込みのものと同じローテーションに入れます。

[`spinnerTipsEnabled`](#spinnertipsenabled) を `false` に設定すると、Claude Code はすべてのヒント（あなたのものを含む）を非表示にします。

* **スコープ**: [`任意のファイル`](#scopes)。Claude Code はヒントオブジェクト、`tipsFile`、`label`、および `excludeDefault` をユーザー設定、`--settings` フラグ、およびマネージド設定から尊重します。プロジェクトおよびローカル設定からは、プレーン文字列ヒントのみを読み取ります。
* **タイプ**: `tips`、`tipsFile`、`label`、および `excludeDefault` フィールドを持つオブジェクト。各フィールドはオプションです
* **デフォルト**: 未設定、Claude Code は組み込みヒントのみを表示します

ヒントオブジェクト、`tipsFile`、`label`、およびスコープ行のルール（プロジェクトおよびローカル設定がプレーン文字列のみを提供）には Claude Code v2.1.247 以降が必要です。

各 `tips` エントリはプレーン文字列またはこれらのフィールドを持つオブジェクトです:

| フィールド | 必須 | 説明 |
| :- | :- | :- |
| `id` | はい | 最大 64 文字、数字、`.`、`_`、または `-`。Claude Code はヒントの表示履歴をキーにするため、ヒントのクールダウンはリストの並べ替えを生き残ります。同じ id を持つ 2 つのエントリのうち、Claude Code は最初のものを使用します |
| `text` | はい | ヒント、最大 500 文字の 1 行。Claude Code は ANSI エスケープと制御文字を削除し、空白を折りたたみます |
| `cooldownSessions` | いいえ | Claude Code がヒントを再度表示する前に待機するセッション数、`0` から `1000`、デフォルト `0` |
| `priority` | いいえ | 同じ期間表示されていないヒント間の順序、より高い最初、`-10` から `10`、デフォルト `0` |

Claude Code はプレーン文字列をこれらのデフォルトを持つヒントとして読み取り、位置ベースの id を読み取るため、リストを並べ替えるとその表示履歴がリセットされます。ヒントに `id` を付けて、編集全体で履歴を保持します。

Claude Code は `tips` と `tipsFile` 全体で最大 200 個のヒントを読み取り、設定ファイルを拒否する代わりに、デバッグ警告で無効なエントリを削除します。

残りのフィールドを使用して、ヒントファイルに名前を付け、プレフィックスを設定し、組み込みヒントを非表示にします:

* `tipsFile`: ローカル JSON ファイルへの絶対パスまたは `~/` パス。同じエントリの配列、またはオブジェクト（`tips` 配列を持つ）を保持します。最大 256 KB。Claude Code はプロセスごとに 1 回ファイルを読み取るため、次の起動時に編集が読み込まれます。[サーバー管理設定](/docs/ja/server-managed-settings)を通じて設定することはできません。インライン `tips` をそこに展開するか、オンディスク `managed-settings.json` にパスを展開します。
* `label`: Claude Code がユーザー、`--settings`、およびマネージド設定からのヒントの前に表示するプレフィックス。最大 40 文字。デフォルトは `Tip`、組み込みヒントと同じプレフィックスであり、プロジェクトおよびローカル設定からのヒントは常にそれを使用します。
* `excludeDefault`: `true` に設定して、組み込みヒントを非表示にし、あなたのヒントのみを表示します。Claude Code がヒントを読み込めない場合（例えば `tipsFile` が存在しないか、すべてのエントリが無効な場合）、空のスピナーの代わりに組み込みローテーションを保持します。

複数の設定ファイルがキーを設定する場合、Claude Code はすべてのファイルからヒントを表示し、マネージド設定、`--settings` フラグ、およびユーザー設定のうち、各 `tipsFile`、`label`、および `excludeDefault` を設定する最高優先度のものから取得します。

この例（ユーザー設定）は、プレーン文字列ヒントとオブジェクトヒントを `Acme tip` プレフィックスの下のローテーションに追加します:

```json settings.json theme={null}
{
  "spinnerTipsOverride": {
    "label": "Acme tip",
    "tips": [
      "Run /review before opening a PR",
      {
        "id": "gateway-errors",
        "text": "Seeing 5xx errors? Check the gateway status page first",
        "cooldownSessions": 5,
        "priority": 2
      }
    ]
  }
}
```

例の各フィールドは Claude Code がヒントを表示する方法の 1 つを変更します:

* `label`: Claude Code は両方のヒントを `Tip: ...` の代わりに `Acme tip: ...` として表示します。
* プレーン文字列: Claude Code はデフォルトを付与するため、次のセッションで再度表示される可能性があります。
* `id`: Claude Code は 2 番目のヒントの表示履歴を `gateway-errors` にキーにするため、そのクールダウンはヒントを追加または並べ替えた後も適用されます。
* `cooldownSessions`: Claude Code が `gateway-errors` ヒントを表示した後、そのヒントを 5 セッション後まで再度表示しません。
* `priority`: `gateway-errors` ヒントと別のヒントが同じ期間表示されていない場合（例えば、どちらも表示されていない場合）、Claude Code は `gateway-errors` を最初に表示します。プレーン文字列はデフォルト優先度 `0` を持ちます。

Claude が作業している間、Claude Code はあなたのプレフィックス（例えば `Acme tip: Run /review before opening a PR`）でスピナーにあなたのヒントを表示します。

<h3 id="spinnerverbs">
  `spinnerVerbs`
</h3>

ターンが進行中の間、スピナーは「Accomplishing」、「Architecting」、または「Baking」などのローテーション動詞を表示します。このキーを使用して、そのローテーションに独自の動詞を追加するか、組み込みリストを置き換えます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: `verbs` 文字列の配列と `mode` を持つオブジェクト。以下のいずれか:
  * `"append"`: Claude Code は組み込みセットに動詞を追加します
  * `"replace"`: Claude Code はあなたの動詞のみを表示します
* **デフォルト**: 未設定、Claude Code は組み込み動詞を使用します

この例は 2 つの動詞を組み込みセットに追加します:

```json settings.json theme={null}
{
  "spinnerVerbs": {
    "mode": "append",
    "verbs": ["Pondering", "Crafting"]
  }
}
```

`"replace"` モードで空の `verbs` 配列の場合、Claude Code は組み込み動詞を保持します。

<h3 id="statusline">
  `statusLine`
</h3>

[ステータスライン](/docs/ja/statusline)をプロンプトの下にレンダリングする独自のコマンドを実行します。モデル、コスト、git ブランチなどのコンテキストを含みます。オプションのフィールドは間隔を調整し、定期的な再実行を追加し、スクリプトが `vim.mode` 自体をレンダリングする場合は組み込みの vim モードインジケーターを非表示にします。

* **スコープ**: [`任意のファイル`](#scopes)。[`allowManagedHooksOnly`](#allowmanagedhooksonly) がオンの場合、または [`disableAllHooks`](#disableallhooks) がマネージド設定の外で設定されている場合、マネージド設定値のみが実行されます。
* **タイプ**: `type` を `"command"` に設定し、`command` 文字列を持つオブジェクト。オプションで `padding` を文字数として、`refreshInterval` を秒数として（最小 `1`）、`hideVimModeIndicator` をブール値として
* **デフォルト**: 未設定、ステータスラインなし

この例はモデル名とコンテキスト使用量を出力し、2 文字の水平間隔を追加します:

```json settings.json theme={null}
{
  "statusLine": {
    "type": "command",
    "command": "jq -r '\"[\\(.model.display_name)] \\(.context_window.used_percentage // 0)% context\"'",
    "padding": 2
  }
}
```

例には[`jq`](https://jqlang.org/)がインストールされている必要があり、シェルで実行されます。PowerShell および Git Bash の同等物については、[Windows 設定](/docs/ja/statusline#windows-configuration)を参照してください。完全なセットアップについては、[ステータスラインを手動で設定](/docs/ja/statusline#manually-configure-a-status-line)を参照してください。

<h3 id="subagentstatusline">
  `subagentStatusLine`
</h3>

Claude が[サブエージェント](/docs/ja/sub-agents)を実行する場合、Claude Code はプロンプトの下のタスク表示にそれらをリストします。サブエージェントごとに 1 行。`name · description · token count` を表示します。このキーを使用すると、独自のコマンドを実行してそれらの行を書き直すことができます。例えば、各サブエージェントのコンテキスト使用量をパーセンテージとして表示します。各リフレッシュで、Claude Code は表示されている行を 1 つの JSON オブジェクトとして stdin に送信します。`tasks` 配列は各サブエージェントの `id`、`name`、`status`、`model`、`tokenCount` などを含みます。書き直した各 `id` の行を `{"id", "content"}` 行として置き換えます。書き直さない行はデフォルトレンダリングを保持します。

* **スコープ**: [`任意のファイル`](#scopes)。[`allowManagedHooksOnly`](#allowmanagedhooksonly) がオンの場合、または [`disableAllHooks`](#disableallhooks) がマネージド設定の外で設定されている場合、マネージド設定値のみが実行されます。
* **タイプ**: `type` を `"command"` に設定し、`command` 文字列を持つオブジェクト
* **デフォルト**: 未設定、Claude Code はデフォルト行をレンダリングします

```json settings.json theme={null}
{
  "subagentStatusLine": {
    "type": "command",
    "command": "jq -c '.tasks[] | {id, content: \"\\(.name): \\(.tokenCount) tokens\"}'"
  }
}
```

[サブエージェントステータスライン](/docs/ja/statusline#subagent-status-lines)を参照してください。

<h3 id="syntaxhighlightingdisabled">
  `syntaxHighlightingDisabled`
</h3>

Claude Code は組み込みハイライターを使用して、ターミナルに表示される diff、コードブロック、ファイルプレビューで言語別にコードを色付けします。プラグインまたは言語サーバーは関与しません。このキーを `true` に設定して、代わりにプレーンテキストとして表示します。例えば、色がターミナルテーマと競合する場合やスクリーンリーダーを遅くする場合。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は diff、コードブロック、ファイルプレビューの構文ハイライトをオフにします
  * `false`: Claude Code は構文をハイライトします
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "syntaxHighlightingDisabled": true
}
```

<h3 id="terminalprogressbarenabled">
  `terminalProgressBarEnabled`
</h3>

一部のターミナルは、それらで実行されているプログラムのタブまたはタスクバーに進捗インジケーターを表示できます。Claude が作業している間、Claude Code はターミナルに進行中の状態を報告するため、別のタブまたはウィンドウからセッションがまだビジーかどうかを確認できます。[バックグラウンドサブエージェント](/docs/ja/sub-agents#run-subagents-in-foreground-or-background)または[動的ワークフロー](/docs/ja/workflows)がまだ実行されている間、インジケーターはターンの終了後も表示されたままになり、セッションがアイドル状態になるとクリアされます。

Claude Code はインジケーターをサポートするターミナルでのみ報告します。ConEmu、Ghostty 1.2.0 以降、および iTerm2 3.6.6 以降。このキーを `false` に設定して、Claude Code がそれを報告するのを停止します。`/config` に**ターミナル進捗バー**として表示されます。

* **スコープ**: [`任意のファイル`](#scopes)。古いバージョンの `~/.claude.json` の値は、設定ファイルがそれを設定しない場合に適用されます。
* **タイプ**: ブール値
  * `true`: サポートするターミナルでターミナル進捗バーが表示されます
  * `false`: Claude Code はターミナル進捗バーを非表示にします
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "terminalProgressBarEnabled": false
}
```

<h3 id="terminaltitlefromrename">
  `terminalTitleFromRename`
</h3>

Claude Code はターミナルタブのタイトルを設定します。デフォルトでは、会話から生成されたタイトルを使用し、`/rename` または `--name` で[セッションに名前を付ける](/docs/ja/sessions#name-your-sessions)と、タブはその名前を代わりに表示します。このキーを `false` に設定して、セッションに名前を付けた後も、生成されたタイトルをタブに保持します。名前自体は引き続き適用されるため、`/resume <name>` とセッションピッカーはそれを見つけます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: ターミナルタブのタイトルは設定したセッション名を表示します
  * `false`: タブは会話から生成された Claude Code のタイトルを保持します
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "terminalTitleFromRename": false
}
```

Claude Code がターミナルタイトルを更新するのを完全に停止するには、代わりに [`CLAUDE_CODE_DISABLE_TERMINAL_TITLE`](/docs/ja/env-vars) を `1` に設定します。

<h3 id="theme">
  `theme`
</h3>

インターフェースのカラーテーマを選択します。`/config` に**テーマ**として表示されます。

* **スコープ**: [`任意のファイル`](#scopes)。古いバージョンの `~/.claude.json` の値は、設定ファイルがそれを設定しない場合に適用されます。
* **タイプ**: 文字列、以下のいずれか:
  * `"auto"`: ターミナルの明るいまたは暗い背景に一致します
  * `"dark"`: ダークテーマ
  * `"light"`: ライトテーマ
  * `"dark-daltonized"`: 色覚異常フレンドリーな色を持つダークテーマ
  * `"light-daltonized"`: 色覚異常フレンドリーな色を持つライトテーマ
  * `"dark-ansi"`: ターミナルの ANSI カラーパレットのみを使用するダークテーマ
  * `"light-ansi"`: ターミナルの ANSI カラーパレットのみを使用するライトテーマ
  * `"custom:<slug>"` または `"custom:<plugin-name>:<slug>"`: `~/.claude/themes/` またはプラグインからのカスタムテーマ
* **デフォルト**: `"dark"`

```json settings.json theme={null}
{
  "theme": "light-daltonized"
}
```

[カスタムテーマを作成](/docs/ja/terminal-config#create-a-custom-theme)を参照してください。

<h3 id="timeformat">
  `timeFormat`
</h3>

Claude Code がインターフェースに表示する時刻の書き方を選択します。例えば、各ターン期間メッセージの終わりの `done 6:05 PM` と[トランスクリプトビューアー](/docs/ja/interactive-mode#transcript-viewer)のタイムスタンプ。プリセットを選択するには、`/config` を実行して**時間形式**を設定します。Claude Code v2.1.257 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか:
  * `"auto"`: 未設定と同じです。各時刻は組み込み形式を保持し、ターン期間メッセージではロケールに従います
  * `"12-hour"`: 12 時間制
  * `"24-hour"`: 24 時間制
  * `"24-hour-utc"`: UTC での 24 時間制。分の後に `Z` が付きます。例えば `18:05Z`。Claude Code はこのプリセットの [`timeZone`](#timezone) を無視します
  * `"%H:%M"` などの strftime パターン: Claude Code はパターンで各時刻を書きます。`%` を含む値はパターンであり、プリセット外の他の値は `"auto"` としてカウントされます
* **デフォルト**: `"auto"`

```json settings.json theme={null}
{
  "timeFormat": "24-hour"
}
```

`/config` はプリセットのみを提供するため、strftime パターンを使用するには、キーを設定ファイルに追加します。この例は各時刻を 2 桁の 24 時間制として表示します:

```json settings.json theme={null}
{
  "timeFormat": "%H:%M"
}
```

ターン期間メッセージとトランスクリプトビューアーは `18:05` などの時刻を表示します。トランスクリプトビューアーでは、パターンはタイムスタンプ全体であるため、日付をそこに含める場合は日付ディレクティブを追加します。この例は時計の前に日付を配置します:

```json settings.json theme={null}
{
  "timeFormat": "%Y-%m-%d %H:%M"
}
```

同じサーフェスは `2026-09-01 18:05` などの時刻を表示します。

<h3 id="timezone">
  `timeZone`
</h3>

インターフェースの時刻をシステムの時刻以外のタイムゾーンで表示します。[IANA タイムゾーン名](https://www.iana.org/time-zones)（`"UTC"` または `"Europe/Dublin"` など）に設定します。[`timeFormat`](#timeformat) が制御する時刻はこのゾーンで表示されます。`timeFormat` が `"24-hour-utc"` の場合、時刻は UTC のままであり、Claude Code はこのキーを無視します。`/config` にはこのキーの行がないため、設定ファイルで設定します。Claude Code v2.1.257 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、IANA タイムゾーン名。Claude Code が名前を認識しない場合、システムタイムゾーンを使用します
* **デフォルト**: 未設定、時刻はシステムタイムゾーンで表示されます

```json settings.json theme={null}
{
  "timeZone": "Europe/Dublin"
}
```

<h3 id="tui">
  `tui`
</h3>

ターミナル UI レンダラーを選択します。ちらつきのない[alt-screen レンダラー](/docs/ja/fullscreen)を仮想スクロールバックで使用するには `"fullscreen"` を使用するか、クラシックメインスクリーンレンダラーには `"default"` を使用します。`/tui fullscreen` または `/tui default` を実行すると、このキーが書き込まれます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか:
  * `"default"`: クラシックメインスクリーンレンダラー
  * `"fullscreen"`: 仮想スクロールバック付きのちらつきのない alt-screen レンダラー
* **デフォルト**: 未設定、Claude Code は[レンダラーを自動的に選択](/docs/ja/fullscreen#fullscreen-by-default)します
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_NO_FLICKER`](/docs/ja/env-vars) と [`CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN`](/docs/ja/env-vars) はこのキーより優先されます。`CLAUDE_CODE_NO_FLICKER=1` はフルスクリーンをオンにし、`CLAUDE_CODE_NO_FLICKER=0` または `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1` はオフにします。両方が設定されている場合、Claude Code はオフにします

```json settings.json theme={null}
{
  "tui": "fullscreen"
}
```

tmux `-CC` の下または Windows への SSH 経由では、Claude Code は `CLAUDE_CODE_NO_FLICKER=1` を設定しない限りクラシックレンダラーを保持します。[エージェントビュー](/docs/ja/agent-view)から開かれたバックグラウンドセッションは、この設定に関係なく常にフルスクリーンレンダラーを使用します。

<h3 id="verbose">
  `verbose`
</h3>

デフォルトでは、トランスクリプトは各ツール呼び出しを短い要約に折りたたみます。例えば、Claude が実行したコマンドと出力の行数。詳細を表示したい場合は `Ctrl+O` を押してトランスクリプト全体を展開ビューに切り替えます。このキーを `true` に設定して、すべてのツール呼び出しの完全な入力と出力をインラインで表示します。フック、MCP サーバー、または長いシェルコマンドをデバッグする場合に便利です。`/config` に**詳細出力**として表示されます。

* **スコープ**: [`任意のファイル`](#scopes)。古いバージョンの `~/.claude.json` の値は、設定ファイルがそれを設定しない場合に適用されます。
* **タイプ**: ブール値
  * `true`: 完全なツール出力が表示されます
  * `false`: ツール出力の切り詰められた要約が表示されます
* **デフォルト**: `false`
* **セッションごとのオーバーライド**: [`--verbose`](/docs/ja/cli-reference#cli-flags) はこのキーより優先されます

```json settings.json theme={null}
{
  "verbose": true
}
```

[`viewMode`](#viewmode) 値またはスティッキー `/focus` 選択はこのキーを毎セッション上書きします。

<h3 id="viewmode">
  `viewMode`
</h3>

Claude Code が開始するトランスクリプトビューを設定します。`"default"`、`"verbose"`、または `"focus"`。設定されている場合、スティッキー `/focus` 選択と [`verbose`](#verbose) 設定の両方を上書きします。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか:
  * `"default"`: 切り詰められたツール出力を持つ通常のトランスクリプト
  * `"verbose"`: 完全なツール出力を持つトランスクリプト
  * `"focus"`: 最後のプロンプトのみ、ツール呼び出しの 1 行の要約（編集 diffstats を含む）、および最終応答。フォーカスビューは[フルスクリーンレンダラー](#tui)が必要です
* **デフォルト**: 未設定、`verbose` 設定と最後の `/focus` 選択が適用されます
* **セッションごとのオーバーライド**: [`--verbose`](/docs/ja/cli-reference#cli-flags) はこのキーより優先されます

```json settings.json theme={null}
{
  "viewMode": "focus"
}
```

<h3 id="viminsertmoderemaps">
  `vimInsertModeRemaps`
</h3>

[vim エディタモード](/docs/ja/interactive-mode#vim-editor-mode)で 2 キーの INSERT モードシーケンスを Escape にマップします。各キーは正確に 2 つの印字可能文字で、順序で入力され、`"<Esc>"` は唯一のサポートされているターゲットです。Claude Code は他のエントリを無視します。Claude Code v2.1.208 以降が必要です。

* **スコープ**: [`ユーザーまたはマネージド`](#scopes)。リポジトリはキーストロークを再マップできません。
* **タイプ**: 2 文字シーケンスを `"<Esc>"` にマップするオブジェクト
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "vimInsertModeRemaps": {
    "jj": "<Esc>"
  }
}
```

`editorMode` が `"vim"` でない限り効果がありません。[INSERT モードキーシーケンスを再マップ](/docs/ja/interactive-mode#remap-insert-mode-key-sequences)を参照してください。Claude Code v2.1.208 以降が必要です。

<h3 id="voice">
  `voice`
</h3>

[音声ディクテーション](/docs/ja/voice-dictation)をオンにし、ディクテーションキーの動作を選択します。Claude Code は `/voice` を実行するとこのオブジェクトを書き込みます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: `enabled` をブール値として、`autoSubmit` をホールドモードのみに適用するブール値として、`mode` を以下のいずれかとして持つオブジェクト:
  * `"hold"`: ディクテーションキーを話している間押し続け、停止するために離します
  * `"tap"`: キーを 1 回タップして記録を開始し、もう一度タップして送信します
* **デフォルト**: 未設定、ディクテーションはオフです。`enabled` が `true` で `mode` が未設定の場合、Claude Code は `"hold"` を使用します

この例はディクテーションをオンにし、キーを 1 回タップして記録を開始し、もう一度タップして送信するようにします:

```json settings.json theme={null}
{
  "voice": {
    "enabled": true,
    "mode": "tap"
  }
}
```

`autoSubmit` はホールドモードでキーを離すときにプロンプトを送信します。音声ディクテーションには claude.ai アカウントが必要です。

<h3 id="voiceenabled">
  `voiceEnabled`
</h3>

<Warning>
  v2.1.92 以降非推奨。[`voice`](#voice) オブジェクトが置き換えました。Claude Code は引き続きそれを読み取るため、古い設定ファイルは機能し続けますが、新しい設定は `voice.enabled` を設定する必要があります。
</Warning>

`voice` オブジェクトより前の単一ブール値形式で音声ディクテーションをオンにします。両方が設定されている場合、`voice.enabled` が適用されます。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: claude.ai アカウントでログインしており、組織のポリシーが音声を許可している場合、音声ディクテーションはオンです。`voice.enabled` が設定されていない限り
  * `false`: 音声ディクテーションはオフです。`voice.enabled` が設定されていない限り
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "voiceEnabled": true
}
```

<h3 id="wheelscrollaccelerationenabled">
  `wheelScrollAccelerationEnabled`
</h3>

[フルスクリーンレンダリング](/docs/ja/fullscreen#mouse-wheel-scrolling)での高速スクロール中にマウスホイールスクロール速度を加速します。ホイールノッチごとに一定のスクロール速度を使用するには `false` に設定します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は高速スクロール中にマウスホイールスクロール速度を加速します
  * `false`: Claude Code はホイールノッチごとに一定の速度でスクロールします
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "wheelScrollAccelerationEnabled": false
}
```

<h2 id="git-and-attribution">
  Git とアトリビューション
</h2>

Claude Code がコミットとプルリクエストに追加するアトリビューションを制御し、git との連携方法を設定します。

<span id="attribution-settings" />

<h3 id="attribution">
  `attribution`
</h3>

Claude Code が git コミットとプルリクエストに追加するアトリビューションをカスタマイズします。コミットはデフォルトで `Co-Authored-By` などの [git トレーラー](https://git-scm.com/docs/git-interpret-trailers) を取得します。プルリクエストの説明はプレーンテキストを取得します。以下のサブキーを使用して各部分を個別に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: `commit` と `pr` 文字列および `sessionUrl` ブール値を含むオブジェクト、または全てのアトリビューションを非表示にする `false`。`false` 値には Claude Code v2.1.281 以降が必要です。それより前のバージョンはこれを拒否し、[それを含むユーザー、プロジェクト、またはローカル設定ファイル全体をスキップします](/docs/ja/settings#fix-a-broken-settings-file)
* **デフォルト**: 未設定。Claude Code は各サブキーの下に表示される標準アトリビューションを使用します

全てのアトリビューションを非表示にするには、`attribution` を `false` に設定します。それより前のバージョンも読み込む設定ファイルでは、[`commit`](#attribution-commit) と [`pr`](#attribution-pr) を空の文字列に設定し、[`sessionUrl`](#attribution-sessionurl) を `false` に設定してください。

この例はコミットアトリビューションを置き換え、プルリクエストアトリビューションを削除し、セッションリンクを削除します。

```json settings.json theme={null}
{
  "attribution": {
    "commit": "Generated with AI\n\nCo-Authored-By: AI <ai@example.com>",
    "pr": "",
    "sessionUrl": false
  }
}
```

`commit` または `pr` を設定すると、Claude Code は非推奨の `includeCoAuthoredBy` 設定を無視し、設定しなかった方のデフォルトテキストを使用します。

Claude Code は、CLAUDE.md または [memory](/docs/ja/memory) ルールなど、アトリビューションに関するカスタマー独自の命令が、[managed settings](/docs/ja/managed-settings) で設定されている場合を除き、これらのコミットおよび PR 行より優先されることを Claude に伝えます。

<h3 id="includecoauthoredby">
  `includeCoAuthoredBy`
</h3>

<Warning>
  v2.0.62 以降非推奨。[`attribution`](#attribution) に置き換えられました。Claude Code はまだこれを読み込みますが、新しい設定は `attribution` を設定する必要があります。
</Warning>

このキーを置き換える [`attribution`](#attribution) を代わりに使用してください。これにより、コミットトレーラー、プルリクエストテキスト、セッションリンクを個別に変更または非表示にできます。Claude Code は `attribution` より前の設定ファイルからの `includeCoAuthoredBy: false` を引き続き尊重しますが、`attribution.commit` または `attribution.pr` を設定すると無視します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: ブール値
  * `true`: 未設定と同じ。Claude Code はコミットトレーラーとプルリクエストアトリビューションテキストを追加します
  * `false`: Claude Code はコミットトレーラーとプルリクエストアトリビューションテキストの両方を省略します。ただし、`attribution` が `commit` または `pr` を設定する場合は、[`attribution`](#attribution) ルールが適用されます
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "includeCoAuthoredBy": false
}
```

全てのアトリビューションを非表示にするには、[`attribution`](#attribution) を参照してください。

<h3 id="includegitinstructions">
  `includeGitInstructions`
</h3>

Claude Code は git 関連の 2 つの部分をコンテキストとして Claude に提供します。Bash ツールの説明にあるコミットとプルリクエストの書き方に関する組み込み命令と、リポジトリの git ステータススナップショット（現在のブランチ、メインブランチ、`git status` 出力、最近のコミット）です。Claude Code はコンバーセーション開始時にスナップショットを読み込みます。

このキーを `false` に設定して両方を除外します。例えば、独自の git ワークフロースキルを使用する場合などです。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は組み込みのコミットおよびプルリクエストワークフロー命令と git ステータススナップショットを含めます。クラウドセッションはスナップショットを含めません
  * `false`: Claude Code は両方を除外します
* **デフォルト**: `true`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS`](/docs/ja/env-vars) はこのキーより優先されます（1 セッション）

```json settings.json theme={null}
{
  "includeGitInstructions": false
}
```

<h3 id="prurltemplate">
  `prUrlTemplate`
</h3>

Claude Code がレンダリングする PR リンク（フッターバッジとツール結果サマリー内）を `github.com` の代わりに内部コードレビューツールに指定します。Claude Code は PR URL から `{host}`、`{owner}`、`{repo}`、`{number}`、`{url}` を置き換えます。両方のサーフェス上の [GitLab マージリクエスト](/docs/ja/interactive-mode#gitlab-merge-requests) リンクは GitLab URL を保持します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列。5 つのプレースホルダーのいずれかを使用する URL テンプレート
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "prUrlTemplate": "https://reviews.example.com/{owner}/{repo}/pull/{number}"
}
```

Claude Code はそれ自体がレンダリングするリンクにのみテンプレートを適用します。Claude がメッセージに書き込む PR 番号（`#123` など）は Claude が書き込んだままです。`/pull/<number>` の形状を持たない URL は変更されません。

<h3 id="attribution-commit">
  `attribution.commit`
</h3>

Claude Code が git コミットに追加するアトリビューションテキスト（トレーラーを含む）を設定します。コミットアトリビューションを非表示にするには、空の文字列に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列
* **デフォルト**: 未設定。Claude Code は `Co-Authored-By: <name> <noreply@anthropic.com>` を追加します。名前はコミットが作成されるときに使用されているモデル（`Claude Sonnet 5` など）です。[subagent](/docs/ja/sub-agents) がコミットを作成する場合、トレーラーは subagent のモデルに名前を付けます。
  * Claude Code がモデルを Claude モデルとして認識しているが、その正確なバージョンを確認できない場合、`Claude` のみを書き込みます。
  * モデル ID をカスタム [`ANTHROPIC_BASE_URL`](/docs/ja/env-vars) を通じて提供されるサードパーティモデルなど、Claude モデルと一致させることができない場合、`Claude Code` を書き込みます。

この例はデフォルトトレーラーをカスタム行とカスタム `Co-Authored-By` トレーラーに置き換えます。

```json settings.json theme={null}
{
  "attribution": {
    "commit": "Generated with AI\n\nCo-Authored-By: AI <ai@example.com>"
  }
}
```

<h3 id="attribution-pr">
  `attribution.pr`
</h3>

Claude Code がプルリクエストの説明に追加するアトリビューションテキストを設定します。プルリクエストアトリビューションを非表示にするには、空の文字列に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列
* **デフォルト**: 未設定。Claude Code は `🤖 Generated with [Claude Code](https://claude.com/claude-code)` を追加します

```json settings.json theme={null}
{
  "attribution": {
    "pr": ""
  }
}
```

<h3 id="attribution-sessionurl">
  `attribution.sessionUrl`
</h3>

Claude Code が [クラウド](/docs/ja/claude-code-on-the-web) または [Remote Control](/docs/ja/remote-control) セッションからコミットするか、プルリクエストを開くときに claude.ai セッションリンクを追加するかどうかを選択します。Claude Code はコミット上に `Claude-Session` トレーラーとしてリンクを追加し、プルリクエストの説明にリンクとして追加します。リンクを省略するには `false` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code はクラウドまたは Remote Control セッションからコミットするか、プルリクエストを開くときに claude.ai セッションリンクを追加します
  * `false`: Claude Code はリンクを省略します
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "attribution": {
    "sessionUrl": false
  }
}
```

<span id="hook-configuration" />

<span id="hook-and-skill-settings" />

<h2 id="hooks-and-automation">
  フックと自動化
</h2>

フックを登録し、実行するフックを制限し、ワークフローを制御します。フックイベントとペイロードについては、[フックリファレンス](/docs/ja/hooks)を参照してください。

<h3 id="allowedhttphookurls">
  `allowedHttpHookUrls`
</h3>

[HTTP フック](/docs/ja/hooks#http-hook-fields)がターゲットできる URL を制限します。このキーを定義すると、Claude Code は HTTP フックを実行するのはその URL がパターンの 1 つと一致する場合のみで、残りはブロックして実行しません。空の配列はすべての HTTP フックをブロックします。

* **スコープ**: [`Any file`](#scopes)。配列は設定ファイル全体でマージされます。
* **型**: URL パターンの配列。ワイルドカードとして `*` を使用
* **デフォルト**: 未設定。任意の URL が許可されます

この例は `https://hooks.example.com/` 下のすべての URL と任意の `http://localhost` URL を許可します:

```json settings.json theme={null}
{
  "allowedHttpHookUrls": ["https://hooks.example.com/*", "http://localhost:*"]
}
```

ホスト名マッチングは大文字と小文字を区別せず、完全修飾ドメイン名を示す末尾のドット付きの `hooks.example.com.` を `hooks.example.com` と同じように扱います。これは DNS の扱い方と同じです。許可リストはすべてのソースからのフック（管理設定を含む）に適用されます。

<h3 id="allowmanagedhooksonly">
  `allowManagedHooksOnly`
</h3>

フック実行を組織がデプロイするフックに制限します。

* **スコープ**: [`Managed`](#scopes)
* **型**: ブール値
  * `true`: 管理フックのみが実行され、Agent SDK フックと管理設定が強制有効にするプラグインからのフックも実行されます。[`allowManagedHooksOnly` 下で実行されるもの](#what-runs-under-allowmanagedhooksonly)を参照してください
  * `false`: すべての設定スコープとプラグインからのフックが実行されます
* **デフォルト**: 未設定。すべての設定スコープとプラグインからのフックが実行されます

```json managed-settings.json theme={null}
{
  "allowManagedHooksOnly": true
}
```

<h4 id="what-runs-under-allowmanagedhooksonly">
  `allowManagedHooksOnly` 下で実行されるもの
</h4>

これを `true` に設定すると、Claude Code はどのフックとフック類似コマンドをロードするかを変更します:

* **管理フックと SDK フックが実行されます**: 管理設定からのフックと [Agent SDK](/docs/ja/agent-sdk/overview) がプロセス内で登録するフック
* **強制有効プラグインフックが実行されます**: 管理設定が [`enabledPlugins`](#enabledplugins) を通じて強制有効にするプラグインからのフック。Claude Code は完全な `plugin@marketplace` ID でマッチするため、別のマーケットプレイスからの同じ名前のプラグインはブロックされたままです。これにより、組織マーケットプレイスを通じて検証済みフックを配布しながら、その他すべてをブロックできます。このようなプラグイン内の [mod](/docs/ja/plugins/mods/overview) は、[組織のものとしてカウント](/docs/ja/plugins/mods/admin#install-your-organizations-mods)される場合のみロードされます
* **その他すべてはブロックされます**: ユーザー、プロジェクト、ローカルフック、他のインストール済みプラグインからのフックと mod、エージェントのフロントマターで宣言されたフック。[Claude Code に組み込まれた mod](/docs/ja/plugins/mods/overview#mods-built-into-claude-code) は実行し続けます。ユーザーの mod のみをブロックするには、代わりに [`allowManagedModsOnly`](/docs/ja/plugins/mods/admin#set-options-on-the-built-in-guard) を設定してください。
* **コマンドソースプラグインは無効になります**: Claude Code は [`command` ソース](/docs/ja/plugins/marketplace-reference#command-plugin-source)を持つプラグイン（管理 `enabledPlugins` で強制有効にされたプラグインを含む）も無効にします。ただし、[`disableCommandPluginSources`](#disablecommandpluginsources) を明示的に `false` に設定した場合を除きます
* **マーケットプレイス `headersHelper` コマンドはブロックされます**: Claude Code はマーケットプレイス [`headersHelper` コマンド](/docs/ja/plugins/host-marketplace#authenticate-archive-downloads)もブロックします。ただし、[`disableCommandPluginSources`](#disablecommandpluginsources) が明示的に `false` に設定されている場合、または管理設定自体が宣言するマーケットプレイスの場合を除きます。Claude Code v2.1.238 以降が必要です
* **ステータスラインとファイル提案は管理設定に絞られます**: Claude Code は [`statusLine`](/docs/ja/statusline)、[`fileSuggestion`](#filesuggestion)、[`subagentStatusLine`](/docs/ja/statusline#subagent-status-lines) を管理設定からのみ読み込みます。[ステータスラインとファイル提案ゲート](#status-line-and-file-suggestion-gates)に従います

このキーが設定されている間、[`/goal`](/docs/ja/goal) コマンドは実行できません。これはフックに依存しているためです。

<h3 id="disableallhooks">
  `disableAllHooks`
</h3>

[フック](/docs/ja/hooks#disable-or-remove-hooks)、カスタム [ステータスライン](/docs/ja/statusline)、カスタム [ファイル提案](#filesuggestion) コマンドをオフにします。これらを設定から削除せずに一時的にオフにするために使用します。

* **スコープ**: [`Any file`](#scopes)。管理設定のみが管理フックを無効にできます。
* **型**: ブール値
  * `true`: Claude Code はフック、カスタムステータスライン、カスタムファイル提案コマンドをオフにします
  * `false`: フック、ステータスライン、ファイル提案コマンドが実行されます
* **デフォルト**: 未設定。フックが実行されます

```json settings.json theme={null}
{
  "disableAllHooks": true
}
```

到達範囲はキーを持つファイルによって異なります:

* **管理設定内**: Claude Code はすべての設定済みフック（管理フックを含む）を無効にし、[Agent SDK](/docs/ja/agent-sdk/overview) がプロセス内で登録するフックは実行し続けます
* **他の設定ファイル内**: Claude Code はユーザー、プロジェクト、ローカル、プラグインフックを無効にします。管理フック、Agent SDK フック、管理 [`enabledPlugins`](#enabledplugins) で強制有効にされたプラグインからのフックは実行し続けます

このキーは、コードがフックを登録するプラグインである [mod](/docs/ja/plugins/mods/overview) も停止します:

* **管理設定内**: 組織のものを含め、インストール済みのすべてのプラグイン内の mod が停止します
* **他の設定ファイル内**: ユーザーがインストールした mod が停止し、[組織の mod](/docs/ja/plugins/mods/admin#install-your-organizations-mods) は実行し続けます

Claude Code に組み込まれた mod は、どちらの場合も実行し続けます。それぞれに[独自のスイッチ](/docs/ja/plugins/mods/overview#mods-built-into-claude-code)があります。

管理設定がこのキーを設定している場合に Agent SDK フックを実行し続けるには、Claude Code v2.1.242 以降が必要です。

フックが無効な間、[`/goal`](/docs/ja/goal) コマンドは実行できず、`/hooks` メニューはフックの代わりに通知を表示します。

<h4 id="status-line-and-file-suggestion-gates">
  ステータスラインとファイル提案ゲート
</h4>

Claude Code は `statusLine`、`fileSuggestion`、`subagentStatusLine` について、この順序で 2 つの決定を行います:

* **完全にオフ**: 管理設定が `disableAllHooks` を設定している場合、またはフォルダが設定ファイル内のフックと同じ [ワークスペーストラストルール](/docs/ja/permissions#what-runs-before-you-trust-a-folder)の下で信頼されていない場合
* **管理設定に絞られます**: [`allowManagedHooksOnly`](#allowmanagedhooksonly) が設定されている場合、[設定の優先順位](/docs/ja/hooks#disable-or-remove-hooks)が適用された後に管理設定外で `disableAllHooks` が `true` である場合、または `--safe-mode` で Claude Code を起動した場合

絞られた場合、Claude Code はデプロイされた管理値があれば実行します。そうでない場合は警告なしにユーザーの値をスキップします: ステータスラインは無効になり、`@` オートコンプリートは組み込みファイル提案にフォールバックします。

<h3 id="disableworkflows">
  `disableWorkflows`
</h3>

[動的ワークフロー](/docs/ja/workflows#turn-workflows-off)と、管理設定を通じた組織など、設定が到達するすべてのユーザーのためのバンドルワークフローコマンドをオフにします。自分自身のためだけにワークフローをオンまたはオフにするには、代わりに [`enableWorkflows`](#enableworkflows) を使用してください。これは `/config` の **Dynamic workflows** トグルがユーザー設定に書き込みます。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: Claude Code は動的ワークフローと、設定が到達するすべてのユーザーのためのバンドルワークフローコマンドをオフにします
  * `false`: 未設定と同じです。ワークフローがオンかどうかは [`enableWorkflows`](#enableworkflows) とプランのデフォルトに従います
* **デフォルト**: `false`
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_WORKFLOWS`](/docs/ja/env-vars) は 1 つのセッションのワークフローをオフにします。2 つのうちどちらがオフにするかに関わらず、もう一方はオンに戻すことはできません

```json settings.json theme={null}
{
  "disableWorkflows": true
}
```

<h3 id="enableworkflows">
  `enableWorkflows`
</h3>

プランのデフォルトが望むものでない場合、自分自身のために [動的ワークフロー](/docs/ja/workflows)をオンまたはオフにします。`/config` に **Dynamic workflows** として表示され、このキーをユーザー設定に書き込み、プランのデフォルトに戻すときに再度削除します。管理設定からすべてのユーザーのためにワークフローをオフにするには、代わりに [`disableWorkflows`](#disableworkflows) を使用してください。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: Claude Code は自分自身の動的ワークフローをオンにします
  * `false`: Claude Code は自分自身の動的ワークフローをオフにします
* **デフォルト**: 未設定。ワークフローはオンです。ただし Pro プランではオフです
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_WORKFLOWS`](/docs/ja/env-vars) は 1 つのセッションのワークフローをオフにし、ここで `true` はそれが設定されている間はワークフローをオンに戻すことはできません

```json settings.json theme={null}
{
  "enableWorkflows": true
}
```

[`disableWorkflows`](#disableworkflows) と組織のワークフローポリシーも優先されます: `enableWorkflows: true` はいずれかのソースがワークフローをオフにしている間はワークフローをオンに戻すことはできません。Claude Code は、ユーザー設定以外のソースが `enableWorkflows` を設定している場合、または `disableWorkflows` を `true` に設定している場合、`/config` 行を非表示にします。

<h3 id="hooks">
  `hooks`
</h3>

Claude Code のライフサイクルの特定の時点（ツール呼び出しの前やセッション開始時など）で、[フック](/docs/ja/hooks)として独自のコマンド、プロンプト、エージェント、HTTP リクエスト、または MCP ツールを実行します。[フックリファレンス](/docs/ja/hooks#hook-events)はすべてのイベント、ペイロード、終了コードをリストします。各イベントは matcher グループのリストにマップされ、各グループは matcher が適用されるときに実行するハンドラーをリストします。

* **スコープ**: [`Any file`](#scopes)。フックは互いに置き換えられるのではなくファイル全体でマージされ、管理設定からのフックは他のファイルから削除できません。
* **型**: [フックイベント](/docs/ja/hooks#hook-events)でキー付けされたオブジェクト。各値は `"command"`、`"prompt"`、`"agent"`、`"http"`、または `"mcp_tool"` の `type` を持つ `{ "matcher", "hooks" }` グループの配列
* **デフォルト**: 未設定。フックは実行されません

この例はすべての Bash ツール呼び出しの前にスクリプトを実行します:

```json settings.json theme={null}
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "~/.claude/hooks/check-bash.sh" }
        ]
      }
    ]
  }
}
```

すべてのイベント、matcher パターン、ハンドラーフィールドについては、[フックリファレンス](/docs/ja/hooks#configuration)を参照してください。フックをオフにするには、[`disableAllHooks`](#disableallhooks)を参照してください。フックを組織がデプロイするものに制限するには、[`allowManagedHooksOnly`](#allowmanagedhooksonly)を参照してください。

<h3 id="httphookallowedenvvars">
  `httpHookAllowedEnvVars`
</h3>

[HTTP フック](/docs/ja/hooks#http-hook-fields)は環境変数の値をリクエストヘッダーに入れることができます。例えば `Authorization: Bearer $HOOK_TOKEN` ヘッダーですが、フックが独自の `allowedEnvVars` でリストしている変数のみです。このキーはすべての HTTP フックのそのリストに外側の制限を設定します: フックは変数を使用できるのは、独自の `allowedEnvVars` とこのキーの両方がそれを名前付けしている場合のみです。フックの定義がそれを要求している場合でも、フックが読むべきではないシークレットを読むのを防ぐために使用します。

* **スコープ**: [`Any file`](#scopes)。配列は設定ファイル全体でマージされます。
* **型**: 環境変数名の配列
* **デフォルト**: 未設定。各フック独自の `allowedEnvVars` リストが適用されます

この例はヘッダー補間を `MY_TOKEN` と `HOOK_SECRET` に制限します:

```json settings.json theme={null}
{
  "httpHookAllowedEnvVars": ["MY_TOKEN", "HOOK_SECRET"]
}
```

許可リストはすべてのソースからのフック（管理設定を含む）に適用されます。

<h3 id="workflowkeywordtriggerenabled">
  `workflowKeywordTriggerEnabled`
</h3>

プロンプトでキーワード `ultracode` を入力することが [動的ワークフロー](/docs/ja/workflows#ask-for-a-workflow-in-your-prompt)をトリガーするかどうかを選択します。`false` に設定して、トリガーなしで単語を入力します。

* **スコープ**: [`Any file`](#scopes)。`/config` に **Ultracode keyword trigger** として表示されます。
* **型**: ブール値
  * `true`: プロンプトで `ultracode` を入力すると動的ワークフローがトリガーされます
  * `false`: トリガーなしで単語を入力できます
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "workflowKeywordTriggerEnabled": false
}
```

`ultracode` 努力設定、`/workflows`、保存されたワークフローコマンドは影響を受けません。

<h3 id="workflowsizeguideline">
  `workflowSizeGuideline`
</h3>

Claude が書き込む動的ワークフローで [Claude が目指すエージェント数](/docs/ja/workflows#set-a-size-guideline)を設定します。Claude Code は値を Claude に助言として送信します。強制的な上限ではありません: `"small"` は 5 未満のエージェントを要求し、`"medium"` は 10 未満、`"large"` は 50 未満です。ワークフローが費やすものを制限したい場合は `"small"` を選択します。Claude Code v2.1.219 以降が必要です。

* **スコープ**: [`Any file`](#scopes)。そこの値は `/config` の **Dynamic workflow size** 選択肢より優先されます。Claude Code は `~/.claude.json` に保存します。設定ファイルがキーを設定している間、Claude Code はその行を非表示にします。
* **型**: 文字列。以下のいずれか:
  * `"unrestricted"`: ガイドラインなし。Claude はタスクに合わせてワークフローの規模を決めます
  * `"small"`: Claude は 5 未満のエージェントを目指します
  * `"medium"`: Claude は 10 未満のエージェントを目指します
  * `"large"`: Claude は 50 未満のエージェントを目指します
* **デフォルト**: `"medium"`、または Pro プランで Claude Code v2.1.271 以降にサインインしている場合は `"small"`

```json settings.json theme={null}
{
  "workflowSizeGuideline": "small"
}
```

Claude Code v2.1.219 以降が必要です。v2.1.202 から v2.1.218 では、代わりに `/config` でガイドラインを設定します。

<span id="plugin-configuration" />

<span id="manage-plugins" />

<span id="plugin-settings" />

<h2 id="plugins-and-skills">
  プラグインとスキル
</h2>

プラグインを有効にし、マーケットプレイスを登録し、組織が許可するプラグインソースを制限し、どのスキルを読み込むかを制御します。プラグインのインストールとビルドについては、[プラグイン](/docs/ja/plugins/overview)を参照してください。

<h3 id="disablebundledskills">
  `disableBundledSkills`
</h3>

Claude Code に含まれる[スキル](/docs/ja/skills)とワークフローをオフにします。Claude Code はバンドルされたスキルとワークフローを完全に削除し、`/init` などの組み込みコマンドは入力可能なままですがモデルから非表示になります。

* **Scope**: [`Any file`](#scopes)
* **Type**: Boolean
  * `true`: Claude Code はバンドルされたスキルとワークフローを削除し、`/init` などの組み込みコマンドをモデルから非表示にします
  * `false`: バンドルされたスキルが読み込まれます
* **Default**: 未設定の場合、バンドルされたスキルが読み込まれます
* **Per-session overrides**: [`CLAUDE_CODE_DISABLE_BUNDLED_SKILLS`](/docs/ja/env-vars) を `1` に設定すると、1 つのセッションでバンドルされたスキルがオフになります。2 つのうちどちらかがそれらをオフにすると、もう一方はそれらをオンに戻すことができません

```json settings.json theme={null}
{
  "disableBundledSkills": true
}
```

プラグインからのスキル、`.claude/skills/`、および `.claude/commands/` からのスキルは影響を受けません。`/doctor` は組み込みコマンドと同様に入力可能なままです。非表示にするには、代わりに [`DISABLE_DOCTOR_COMMAND`](/docs/ja/env-vars) を設定してください。

<h3 id="disableskillshellexecution">
  `disableSkillShellExecution`
</h3>

[スキル](/docs/ja/skills)およびユーザー、プロジェクト、プラグイン、または追加ディレクトリソースからのカスタムコマンドの `` !`...` `` および ` ```! ` ブロック内のインラインシェル実行をオフにします。Claude Code は各コマンドを実行する代わりに `[shell command execution disabled by policy]` に置き換えます。

* **Scope**: [`Any file`](#scopes)。マネージド設定の `true` は他の場所の `false` でオーバーライドできません。
* **Type**: Boolean
  * `true`: Claude Code は各インラインシェルコマンドを実行する代わりに `[shell command execution disabled by policy]` に置き換えます
  * `false`: インラインシェルが実行されます
* **Default**: 未設定の場合、インラインシェルが実行されます

```json settings.json theme={null}
{
  "disableSkillShellExecution": true
}
```

バンドルされたスキルおよびマネージド設定を通じてデプロイされたスキルは影響を受けません。

<h3 id="skilloverrides">
  `skillOverrides`
</h3>

[スキル](/docs/ja/skills#override-skill-visibility-from-settings)の `SKILL.md` を編集せずに非表示にしたり折りたたんだりします。Claude Code は各スキルの名前の下の値をスキルリストと `/` オートコンプリートに適用します。

* **Scope**: [`Any file`](#scopes)。`/skills` メニューは `.claude/settings.local.json` に書き込みます。
* **Type**: スキル名を次のいずれかにマッピングするオブジェクト:
  * `"on"`: Claude はスキルを認識し、`/name` を入力できます
  * `"name-only"`: Claude はスキルを説明なしで名前で認識します
  * `"user-invocable-only"`: Claude はスキルを認識しませんが、`/name` を入力することはできます
  * `"off"`: Claude はスキルを認識せず、`/name` はオートコンプリートから非表示になります
* **Default**: 未設定の場合、すべてのスキルが `"on"` です

この例は `legacy-context` を Claude に名前のみで表示し、`deploy` を Claude と `/` オートコンプリートから非表示にします:

```json settings.json theme={null}
{
  "skillOverrides": {
    "legacy-context": "name-only",
    "deploy": "off"
  }
}
```

オーバーライドはプラグインスキルには適用されません。プラグインスキルは `/plugin` で管理します。

マネージド設定および `--settings` で渡されたファイルでは、`checkup`（`/doctor` の場合など）のようなバンドルされたスキルのエイリアスのキーも、スキルに適用されます。[エイリアスキーがスキル自体の名前のキーとどのように組み合わされるか](/docs/ja/skills#override-skill-visibility-from-settings)を参照してください。

<h3 id="syncclaudeaiskills">
  `syncClaudeAiSkills`
</h3>

[claude.ai アカウントで有効になっているスキル](/docs/ja/skills#how-synced-skills-behave)のダウンロードをオフにします。Claude Code は、[claude.ai アカウントでサインインするターミナルセッション](/docs/ja/skills#where-synced-skills-load)（対話型および非対話型）および Cowork とクラウドセッションで、それらを `~/.claude/skills/synced/` にダウンロードします。`false` に設定して、そのダウンロードを停止し、既に同期されたスキルの読み込みを停止します。Claude Code は `false` のみを受け入れます。`true` は未設定と同じで、それ以外の場所でオンになっていない場合、同期をオンにしません。

* **Scope**: [`User, local, or managed`](#scopes)、および `--settings` で渡されたファイル。リポジトリはそれをオフにすることはできません。
* **Type**: Boolean
  * `false`: Claude Code は同期されたスキルのダウンロードを停止し、`~/.claude/skills/synced/` にあるスキルの読み込みを停止します。ユーザーまたはマネージド設定では、それらを `~/.claude/skills/.trash/` に移動します
  * `true`: 未設定と同じです
* **Default**: 未設定の場合、claude.ai アカウントでサインインしたセッションはスキルを同期します

この例は、マシンがどのセッションでもアカウントのスキルをダウンロードするのを防ぎます:

```json settings.json theme={null}
{
  "syncClaudeAiSkills": false
}
```

<h3 id="syncclaudeaiplugins">
  `syncClaudeAiPlugins`
</h3>

[claude.ai アカウントで有効になっているプラグイン](/docs/ja/plugins/loading#synced-plugins)のダウンロードをオフにします。Claude Code は、claude.ai アカウントでサインインするターミナルセッションの開始時、および Cowork セッションで、それらを `~/.claude/plugins/synced/` にダウンロードし、各プラグインを `<name>@synced` として読み込みます。`false` に設定して、そのダウンロードを停止し、既に同期されたプラグインの読み込みを停止します。Claude Code は `false` のみを受け入れます。`true` は未設定と同じで、それ以外の場所でオンになっていない場合、同期をオンにしません。Claude Code v2.1.273 以降が必要です。

* **Scope**: [`User, local, or managed`](#scopes)、および `--settings` で渡されたファイル。リポジトリはそれをオフにすることはできません。
* **Type**: Boolean
  * `false`: Claude Code は同期されたプラグインのダウンロードを停止し、`~/.claude/plugins/synced/` にあるプラグインの読み込みを停止します。ユーザーまたはマネージド設定では、それらを `~/.claude/plugins/.trash/` に移動します
  * `true`: 未設定と同じです
* **Default**: 未設定の場合、claude.ai アカウントでサインインしたセッションはプラグインを同期します

すべてのプラグインではなく、1 つの同期されたプラグインをオフにするには、[`enabledPlugins`](#enabledplugins) で `"<name>@synced": false` を設定します。

この例は、マシンがどのセッションでもアカウントのプラグインをダウンロードするのを防ぎます:

```json settings.json theme={null}
{
  "syncClaudeAiPlugins": false
}
```

<h3 id="allowedchannelplugins">
  `allowedChannelPlugins`
</h3>

[チャネル](/docs/ja/channels)プラグインが組織内のセッションにメッセージをプッシュできるかを選択します。設定すると、Claude Code はデフォルトの Anthropic 許可リストの代わりにリストを使用します。各エントリはプラグインとそれが由来するマーケットプレイスに名前を付けます。

* **Scope**: [`Managed`](#scopes)
* **Type**: `marketplace` および `plugin` 文字列を持つオブジェクトの配列。エントリは代わりに `"telegram@claude-plugins-official"` などの `"plugin@marketplace"` 文字列である可能性があり、Claude Code はそれを同等のオブジェクトとして扱います。文字列形式には Claude Code v2.1.267 以降が必要です。以前のバージョンは、1 つを含む場合、全体の `allowedChannelPlugins` 値を拒否します
* **Default**: 未設定の場合、Claude Code はデフォルトの Anthropic 許可リストを使用します

この例はチャネルをオンにし、公式 Anthropic マーケットプレイスからの Telegram プラグインのみを許可します:

```json managed-settings.json theme={null}
{
  "channelsEnabled": true,
  "allowedChannelPlugins": [
    { "marketplace": "claude-plugins-official", "plugin": "telegram" }
  ]
}
```

空の配列はすべてのチャネルプラグインをブロックします。

このキーは、チャネルが [`channelsEnabled`](#channelsenabled) ゲートをアカウントに渡した後に有効になります。Team および Enterprise プラン、およびマネージド設定を持つ Console アカウントでは、`channelsEnabled: true` を意味します。[チャネルプラグインの実行を制限する](/docs/ja/channels#restrict-which-channel-plugins-can-run)を参照してください。

<h3 id="blockedmarketplaces">
  `blockedMarketplaces`
</h3>

組織のプラグインマーケットプレイスソースをブロックします。Claude Code はマーケットプレイスの追加時およびプラグインのインストール、更新、リフレッシュ、自動更新時にブロックリストをチェックするため、ポリシーを設定する前に誰かが追加したマーケットプレイスは、プラグインをフェッチするために使用することはできません。ブロックされたソースはダウンロード前にチェックされるため、ファイルシステムに触れることはありません。

[claude.ai 管理コンソール](/docs/ja/server-managed-settings)でこのキーを設定する場合、claude.ai は、[制限の仕組み](/docs/ja/plugins/org#restrict-what-users-can-install)で説明されているように、組織内の誰かが claude.ai から git リポジトリからマーケットプレイスを追加するときにも適用します。

* **Scope**: [`Managed`](#scopes)
* **Type**: [`strictKnownMarketplaces`](#allowed-source-types) と同じ形式のマーケットプレイスソースオブジェクトの配列
* **Default**: 未設定の場合、マーケットプレイスはブロックされません

この例は、1 つの GitHub リポジトリをマーケットプレイスソースとしてブロックします:

```json managed-settings.json theme={null}
{
  "blockedMarketplaces": [
    { "source": "github", "repo": "untrusted/plugins" }
  ]
}
```

GitHub エントリは、[オーナーワイルドカード形式](#owner-wildcards) `"owner/*"` を使用して、その GitHub オーナーの下のすべてのリポジトリをブロックできます。これには Claude Code v2.1.223 以降が必要です。`{ "source": "skills-dir" }` を追加して、Claude Code が `~/.claude/skills/` から [`@skills-dir` プラグイン](/docs/ja/plugins/loading#plugins-shared-through-a-repository)を読み込むのを停止し、マーケットプレイスを制限しません。[マネージドマーケットプレイス制限](/docs/ja/plugins/org#restrict-what-users-can-install)を参照してください。

<h3 id="channelsenabled">
  `channelsEnabled`
</h3>

組織の[チャネル](/docs/ja/channels)を許可します。claude.ai Team および Enterprise プランでは、Claude Code はこれを `true` に設定するまでチャネルをブロックします。API キーで認証する [Anthropic Console](/docs/ja/authentication#claude-console-authentication) アカウントの場合、チャネルはデフォルトで許可されます。組織がマネージド設定をデプロイする場合、Claude Code はこのキーを `true` に設定するまで、これらのアカウントのチャネルもブロックします。

* **Scope**: [`Managed`](#scopes)
* **Type**: Boolean
  * `true`: Claude Code は組織のチャネルを許可します
  * `false`: 未設定と同じです。チャネルがブロックされるかどうかはプランによって異なります（Default を参照）
* **Default**: 未設定。チャネルは Team および Enterprise プランおよびマネージド設定を持つ Console アカウントでブロックされ、Pro および Max プランおよびマネージド設定のない Console アカウントで許可されます

```json managed-settings.json theme={null}
{
  "channelsEnabled": true
}
```

有効になったら、どのプラグインがチャネルとして登録できるかを制限するには、[`allowedChannelPlugins`](#allowedchannelplugins) を設定します。[エンタープライズコントロール](/docs/ja/channels#enterprise-controls)を参照してください。

<h3 id="disablecommandpluginsources">
  `disableCommandPluginSources`
</h3>

[`command` プラグインソース](/docs/ja/plugins/marketplace-reference#command-plugin-source)をブロックします。これはユーザーのマシンでマーケットプレイス宣言コマンドを実行してプラグインをインストールします。`true` に設定すると、Claude Code はコマンドを実行せず、コマンドソースプラグインをインストールまたは更新せず、既にインストールされているプラグインの読み込みを停止します。`false` に設定して明示的に許可します。コマンドソースをブロックするときはいつでも、`true` に設定するか [`allowManagedHooksOnly`](#allowmanagedhooksonly) の下で未設定のままにするかに関わらず、マーケットプレイス [`headersHelper` コマンド](/docs/ja/plugins/host-marketplace#authenticate-archive-downloads)もブロックします。ただし、マネージド設定自体が宣言するマーケットプレイスは除きます。Claude Code v2.1.229 以降が必要で、`headersHelper` ブロックには v2.1.238 以降が必要です。

* **Scope**: [`Managed`](#scopes)
* **Type**: Boolean
  * `true`: Claude Code はマーケットプレイス宣言コマンドを実行せず、コマンドソースプラグインをインストールまたは更新せず、既にインストールされているプラグインの読み込みを停止します
  * `false`: Claude Code はコマンドソースプラグインを明示的に許可します
* **Default**: 未設定の場合、Claude Code は [`allowManagedHooksOnly`](#allowmanagedhooksonly) に従います。フック実行をマネージド設定に制限する組織はコマンドソースも無効になります

```json managed-settings.json theme={null}
{
  "disableCommandPluginSources": true
}
```

Claude Code v2.1.229 以降が必要です。

<h3 id="pluginsuggestionmarketplaces">
  `pluginSuggestionMarketplaces`
</h3>

スピナーチップおよび `/plugin` **Discover** タブの上部にピン留めされた、コンテキスト内インストール提案として表示できるプラグインのマーケットプレイスに名前を付けます。組み込みのファーストパーティフロントエンド設計チップは影響を受けません。提案は各プラグインのマーケットプレイスエントリの `relevance` 宣言から来ます。

* **Scope**: [`Managed`](#scopes)
* **Type**: マーケットプレイス名の配列
* **Default**: 未設定の場合、マーケットプレイス宣言提案は表示されません

```json managed-settings.json theme={null}
{
  "pluginSuggestionMarketplaces": ["acme-corp-plugins"]
}
```

名前は、マーケットプレイスがマシンに登録され、その登録されたソースが同じマネージド設定でも宣言されている場合にのみ有効になります。その名前の [`extraKnownMarketplaces`](#extraknownmarketplaces) エントリとして、または [`strictKnownMarketplaces`](#strictknownmarketplaces) のエントリとして。Claude Code は、許可リストされた名前の下で別のソースから登録されたマーケットプレイスを無視します。公式マーケットプレイスはソース要件から除外されます。その名前を許可リストするだけで十分です。その名前は公式 Anthropic ソースからのみ登録できるためです。[コンテキストでプラグインを提案する](/docs/ja/plugins/relevance)を参照してください。

<h3 id="plugintrustmessage">
  `pluginTrustMessage`
</h3>

インストール前に Claude Code が表示するプラグイン信頼警告に、組織独自のテキストを追加します。たとえば、内部マーケットプレイスからのプラグインが検証されていることを確認します。

* **Scope**: [`Managed`](#scopes)
* **Type**: 文字列
* **Default**: 未設定の場合、Claude Code は標準警告のみを表示します

```json managed-settings.json theme={null}
{
  "pluginTrustMessage": "All plugins from our marketplace are approved by IT"
}
```

<h3 id="strictknownmarketplaces">
  `strictKnownMarketplaces`
</h3>

組織内のユーザーがプラグインを追加およびインストールできるプラグインマーケットプレイスソースを制限します。Claude Code はマーケットプレイスの追加時およびプラグインのインストール、更新、リフレッシュ、自動更新時に許可リストを実施します。ネットワークまたはファイルシステム操作の前に実施されるため、ポリシーを設定する前に誰かが追加したマーケットプレイスは、そのソースが一致しなくなると使用できません。ブロックされたユーザーはマネージドポリシーに名前を付けるエラーを表示します。

[claude.ai 管理コンソール](/docs/ja/server-managed-settings)でこのキーを設定する場合、claude.ai は、[制限の仕組み](/docs/ja/plugins/org#restrict-what-users-can-install)で説明されているように、組織内の誰かが claude.ai から git リポジトリからマーケットプレイスを追加するときにも適用します。

* **Scope**: [`Managed`](#scopes)
* **Type**: マーケットプレイスソースオブジェクトの配列。[許可されたソースタイプ](#allowed-source-types)を参照してください
* **Default**: 未設定の場合、ユーザーは任意のマーケットプレイスを追加できます。空の配列は、公式 Anthropic マーケットプレイスを含むすべてのマーケットプレイスソースをブロックする完全なロックダウンです

この例は、2 つの GitHub リポジトリを許可します。1 つは `v2.0` ref にピン留めされ、1 つはホストされた `marketplace.json` URL です:

```json managed-settings.json theme={null}
{
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "acme-corp/approved-plugins" },
    { "source": "github", "repo": "acme-corp/security-tools", "ref": "v2.0" },
    { "source": "url", "url": "https://plugins.example.com/marketplace.json" }
  ]
}
```

このキーを `allowedMarketplaces` として書くこともできます。[マーケットプレイスキーエイリアス](#marketplace-key-aliases)は、Claude Code がエイリアスをどのように扱うか、およびどのバージョンがそれを受け入れるかを説明しています。このキーはポリシーゲートです。ユーザーが追加できるものを制御しますが、何も登録しません。制限と事前登録を 1 つのファイルで行うには、[`extraKnownMarketplaces` と組み合わせる](#combine-with-extraknownmarketplaces)を参照してください。ユーザー向けビューについては、[マネージドマーケットプレイス制限](/docs/ja/plugins/org#restrict-what-users-can-install)を参照してください。

<h4 id="allowed-source-types">
  許可されたソースタイプ
</h4>

以下の各エントリは、ソースタイプごとに 1 つの許可リストエントリと、それが受け入れるフィールドを示しています。ほとんどのタイプは正確に一致します。`hostPattern` と `pathPattern` は正規表現で一致し、`github` エントリは[オーナーワイルドカード](#owner-wildcards)を使用できます。

| Source | Example entry | Fields |
| :- | :- | :- |
| `github` | `{ "source": "github", "repo": "acme-corp/plugins", "ref": "main", "path": "marketplace" }` | `repo` 必須; `ref` はブランチまたはタグ; `path` はサブディレクトリ |
| `git` | `{ "source": "git", "url": "https://gitlab.example.com/tools/plugins.git", "ref": "production" }` | `url` 必須; `ref` と `path` は `github` と同じ |
| `url` | `{ "source": "url", "url": "https://plugins.example.com/marketplace.json", "headers": { "Authorization": "Bearer ${TOKEN}" } }` | `url` 必須; `headers` は認証アクセス用の HTTP ヘッダーを追加します |
| `file` | `{ "source": "file", "path": "/opt/acme-corp/plugins/marketplace.json" }` | `path` 必須、`marketplace.json` ファイルへの絶対パス |
| `directory` | `{ "source": "directory", "path": "/opt/acme-corp/approved-marketplaces" }` | `path` 必須、`.claude-plugin/marketplace.json` を含むディレクトリへの絶対パス |
| `hostPattern` | `{ "source": "hostPattern", "hostPattern": "^github\\.example\\.com$" }` | `hostPattern` 必須、マーケットプレイスホストに対して一致する正規表現 |
| `pathPattern` | `{ "source": "pathPattern", "pathPattern": "^/opt/approved/" }` | `pathPattern` 必須、`file` および `directory` ソースの `path` に対して一致する正規表現 |
| `skills-dir` | `{ "source": "skills-dir" }` | フィールドなし。`~/.claude/skills/` プラグインスキャンをオプトバックインします |

3 つのソースタイプはテーブルを超えたルールを持ちます:

* **`url`**: URL マーケットプレイスは `marketplace.json` ファイルのみをダウンロードし、Claude Code はそのサーバーから相対パスでプラグインファイルをフェッチしないため、そのプラグインは相対パス以外の[プラグインソース](/docs/ja/plugins/marketplace-reference#plugin-sources)（同じホストにある可能性があるアーカイブ URL など）を使用する必要があります。相対パスを持つプラグインの場合は、代わりに Git ベースのマーケットプレイスを使用してください。[相対パスを持つプラグインが URL ベースのマーケットプレイスで失敗する](/docs/ja/plugins/troubleshooting#plugins-with-relative-paths-fail-in-url-based-marketplaces)を参照してください。
* **`hostPattern`**: 各リポジトリをリストせずに、内部 GitHub Enterprise または GitLab サーバー上のすべてのマーケットプレイスを許可するために使用します。Claude Code は `github` ソースを `github.com` に対して一致させ、`url` ソースからホスト名を取得し、[git URL](https://git-scm.com/docs/git-clone#_git_urls) の形式に応じて `git` ソースから取得します:

  * `https://` や `ssh://` などのスキーム付き URL: URL のホスト名。
  * スキームなしの SSH アドレス、git の `user@host:path` 形式（`git@git.example.com:tools/plugins.git` など）: `@` と `:` の間のホスト。これは git が接続するホストです。
  * スキームなしの他の形式: ホストなし、したがって `strictKnownMarketplaces` `hostPattern` エントリは一致しません。`blockedMarketplaces` `hostPattern` の場合、Claude Code はより広い形式のセットからホストを取得するため、ブロックリストエントリはそのような形式と一致する可能性があります。v2.1.234 より前では、`strictKnownMarketplaces` `hostPattern` も git が SSH アドレスとして扱わない一部の形式と一致していました。

  `file` および `directory` ソースはホストを持たず、`hostPattern` エントリと一致しません。
* **`pathPattern`**: ネットワークソースの `hostPattern` エントリと共にファイルシステムマーケットプレイスを許可するために使用します。`".*"` はすべてのローカルパスを許可します。`"^/opt/approved/"` などのより狭いパターンはディレクトリに制限します。

空の配列でも、許可リストは Claude Code が [`@skills-dir` プラグイン](/docs/ja/plugins/loading#plugins-shared-through-a-repository) を `~/.claude/skills/` から読み込むのを停止します。それらの読み込みを続けるには、`{ "source": "skills-dir" }` エントリを追加してください。このエントリはこのキーと `blockedMarketplaces` の外では意味がありません。

<h4 id="owner-wildcards">
  オーナーワイルドカード
</h4>

その `repo` 値が `"<owner>/*"` である `github` エントリは、その GitHub オーナーの下のすべてのリポジトリと一致します。オーナーワイルドカードには Claude Code v2.1.223 以降が必要で、`strictKnownMarketplaces` および `blockedMarketplaces` でのみ機能します。`extraKnownMarketplaces` や `/plugin marketplace add` などの他の場所で `github` ソースが表示される場合、`repo` 値は単一のリポジトリに名前を付ける必要があります。v2.1.223 より前では、Claude Code はエントリを文字通り比較したため、許可リストエントリはリポジトリと一致せず、ブロックリストエントリは何もブロックしませんでした。単一リポジトリエントリはすべてのバージョンで実施されます。

このエントリは `acme-corp` 組織内のマーケットプレイスリポジトリを許可します:

```json managed-settings.json theme={null}
{
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "acme-corp/*" }
  ]
}
```

リポジトリ名の位置全体のみがワイルドカードである可能性があります。Claude Code は `*`、`*/plugins`、または `acme-corp/tools-*` などのエントリを無効として無視するため、リポジトリと一致しません。

マッチングルールは 2 つの設定間で異なります:

| Rule | `strictKnownMarketplaces` | `blockedMarketplaces` |
| - | - | - |
| マッチングソーススペリング | `owner/repo` 形式のみ。同じリポジトリをクローンする git URL は一致しません | `github.com` リポジトリに解決する git URL を含む任意のスペリング |
| オーナーの大文字と小文字 | 大文字と小文字を区別します | 大文字と小文字を区別しません |
| `ref` | 正確なエントリルールに従います: `ref` を持つエントリはその正確な ref を持つソースのみと一致し、1 つを持たないエントリは ref を指定しないソースのみと一致します | `ref` を持たないエントリは、一致するリポジトリのすべての ref をブロックします |
| `path` | 正確なエントリルールより緩い: `path` を持つエントリはその正確な値を必要とし、1 つを持たないエントリはリポジトリ内のすべてのパスと一致します | `path` を持たないエントリは、一致するリポジトリのすべてのパスをブロックします |

<h4 id="exact-matching">
  正確なマッチング
</h4>

オーナーワイルドカード `github` エントリと正規表現でマッチングされた `hostPattern` および `pathPattern` エントリを除くすべてのソースタイプについて、Claude Code はユーザーの追加をエントリと正確に一致する場合にのみ許可します。Git ベースのソース `github` および `git` の場合、正確なマッチングはオプションフィールドを含みます:

* `repo` または `url` は正確に一致する必要があります
* `ref` フィールドは正確に一致する必要があります。または両方が未定義である必要があります
* `path` フィールドは正確に一致する必要があります。または両方が未定義である必要があります

たとえば、Claude Code は以下の各ペアを 2 つの異なるソースとして扱います:

* `{ "source": "github", "repo": "acme-corp/plugins" }` および `{ "source": "github", "repo": "acme-corp/plugins", "ref": "main" }`
* `{ "source": "github", "repo": "acme-corp/plugins", "path": "marketplace" }` および `{ "source": "github", "repo": "acme-corp/plugins" }`

<h4 id="allow-only-the-official-marketplace">
  公式マーケットプレイスのみを許可する
</h4>

公式 Anthropic マーケットプレイスのみを許可するには、そのリポジトリをリストします:

```json managed-settings.json theme={null}
{
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "anthropics/claude-plugins-official" }
  ]
}
```

このエントリを使用すると、Claude Code は既に登録されている公式マーケットプレイスを利用可能に保ち、新しいマシンでは、最初に対話的に Claude Code を起動するときにマーケットプレイスを自動的に登録します。自動登録は最も一般的に以下を見逃します:

* マシンの最初の対話的セッションの前に実行される非対話型環境。
* Claude Code が VS Code 拡張機能を通じてのみ実行されたマシン。
* Claude Code が既に対話的ターミナルセッションを実行したマシン。マーケットプレイスをブロックするポリシー（空の配列ロックダウンなど）の下。Claude Code はブロックされた試行を記録し、ポリシーが変更された後は再試行しません。

これらのマシンでは、同じ `managed-settings.json` の [`extraKnownMarketplaces`](#extraknownmarketplaces) にマーケットプレイスを追加して Claude Code が自動的に登録するか、`claude plugin marketplace add anthropics/claude-plugins-official` を実行してください。

<h4 id="combine-with-extraknownmarketplaces">
  `extraKnownMarketplaces` と組み合わせる
</h4>

2 つのキーは異なるジョブを実行します。この表はそれらを比較しています:

| Aspect | `strictKnownMarketplaces` | `extraKnownMarketplaces` |
| - | - | - |
| Purpose | 組織ポリシー実施 | チーム便宜 |
| Settings file | マネージド設定のみ | 任意の設定ファイル |
| Behavior | 許可リストされていない追加をブロック | 不足しているマーケットプレイスを登録 |
| When enforced | ネットワークおよびファイルシステム操作の前 | ユーザーまたはマネージド設定から直ちに。リポジトリのファイルのワークスペース信頼ダイアログの後 |
| Can be overridden | いいえ、最高優先度 | はい、より高い優先度の設定による |
| Source format | 直接ソースオブジェクト | ネストされた `source` オブジェクトを持つ名前付きマーケットプレイス |

すべてのユーザーのマーケットプレイスを制限および事前登録するには、`managed-settings.json` で両方を設定します:

```json managed-settings.json theme={null}
{
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "acme-corp/plugins" }
  ],
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": { "source": "github", "repo": "acme-corp/plugins" }
    }
  }
}
```

`strictKnownMarketplaces` のみが設定されている場合、ユーザーは `/plugin marketplace add` で許可されたマーケットプレイスを自分で追加できます。公式 Anthropic マーケットプレイスは Claude Code が自動的に登録する唯一のマーケットプレイスであり、許可リストがそれを許可する場合のみです。[公式マーケットプレイスのみを許可する](#allow-only-the-official-marketplace)は、それが見逃すマシンをリストしています。

<h3 id="strictpluginonlycustomization">
  `strictPluginOnlyCustomization`
</h3>

ユーザーおよびプロジェクトソースからスキル、エージェント、フック、および MCP サーバーをブロックして、プラグインまたはマネージド設定からのみ来るようにします。[`strictKnownMarketplaces`](#strictknownmarketplaces) と組み合わせて、完全なカスタマイズサプライチェーンを制御します。マーケットプレイス許可リストはユーザーがインストールできるプラグインを制御します。

* **Scope**: [`Managed`](#scopes)
* **Type**: すべての 4 種類のカスタマイズをロックするには `true`、またはロックする種類に名前を付ける配列（`"skills"`、`"agents"`、`"hooks"`、`"mcp"` から）
* **Default**: 未設定の場合、何もロックされません

この例はスキルとフックをロックし、エージェントと MCP サーバーをロック解除したままにします:

```json managed-settings.json theme={null}
{
  "strictPluginOnlyCustomization": ["skills", "hooks"]
}
```

以下の 4 つのサブキーエントリは、各サーフェスがブロックするものと何が読み込まれるかをリストしています。Claude Code は認識しないサーフェス名を無視するため、すべてのクライアントが更新される前に新しいサーフェス名を追加できます。

<h3 id="strictpluginonlycustomization-skills">
  `strictPluginOnlyCustomization.skills`
</h3>

`skills` サーフェスをロックします。Claude Code は `~/.claude/skills/` および `.claude/skills/` からのスキル、`~/.claude/commands/` および `.claude/commands/` からのカスタムコマンド、`--add-dir` ディレクトリの下のスキル、および claude.ai アカウントから同期されたスキルの読み込みを停止し、プラグインスキル、バンドルされたスキル、およびマネージドポリシーディレクトリ内のスキルの読み込みを続けます。

* **Scope**: [`Managed`](#scopes)
* **Type**: [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) 配列内の文字列 `"skills"`
* **Default**: ロックされていません

```json managed-settings.json theme={null}
{
  "strictPluginOnlyCustomization": ["skills"]
}
```

<h3 id="strictpluginonlycustomization-agents">
  `strictPluginOnlyCustomization.agents`
</h3>

`agents` サーフェスをロックします。Claude Code は `~/.claude/agents/` および `.claude/agents/` からのエージェントの読み込みを停止し、プラグインエージェント、組み込みエージェント、およびマネージドポリシーディレクトリ内のエージェントの読み込みを続けます。

* **Scope**: [`Managed`](#scopes)
* **Type**: [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) 配列内の文字列 `"agents"`
* **Default**: ロックされていません

```json managed-settings.json theme={null}
{
  "strictPluginOnlyCustomization": ["agents"]
}
```

<h3 id="strictpluginonlycustomization-hooks">
  `strictPluginOnlyCustomization.hooks`
</h3>

`hooks` サーフェスをロックします。Claude Code はユーザー、プロジェクト、およびローカル `settings.json` からのフックの実行を停止し、プラグインフックおよびマネージド設定内のフックの実行を続けます。

* **Scope**: [`Managed`](#scopes)
* **Type**: [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) 配列内の文字列 `"hooks"`
* **Default**: ロックされていません

```json managed-settings.json theme={null}
{
  "strictPluginOnlyCustomization": ["hooks"]
}
```

<h3 id="strictpluginonlycustomization-mcp">
  `strictPluginOnlyCustomization.mcp`
</h3>

`mcp` サーフェスをロックします。Claude Code は `~/.claude.json` および `.mcp.json` からの MCP サーバーの読み込みを停止し、プラグイン MCP サーバー、[`managed-mcp.json`](/docs/ja/managed-mcp) サーバー、および [`managedMcpServers`](#managedmcpservers) からのサーバーの読み込みを続けます。

* **Scope**: [`Managed`](#scopes)
* **Type**: [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) 配列内の文字列 `"mcp"`
* **Default**: ロックされていません

```json managed-settings.json theme={null}
{
  "strictPluginOnlyCustomization": ["mcp"]
}
```

<h3 id="enabledplugins">
  `enabledPlugins`
</h3>

個別の[プラグイン](/docs/ja/plugins/overview)をオンまたはオフにします。`plugin-name@marketplace-name` でキー付けされます。どのスコープでもエントリを持たないプラグインは、その [`defaultEnabled`](/docs/ja/plugins/manifest-reference#fields) 値にフォールバックします。`/plugin` または `claude plugin enable` でプラグインを有効または無効にすると、Claude Code はこのキーを書き込みます。

* **Scope**: [`Any file`](#scopes)
* **Type**: `plugin-name@marketplace-name` を Boolean にマッピングするオブジェクト
* **Default**: 未設定の場合、各プラグインはその `defaultEnabled` 値に従います

この例は `team-tools` マーケットプレイスから 2 つのプラグインを有効にし、`personal` から 1 つを無効にします:

```json settings.json theme={null}
{
  "enabledPlugins": {
    "code-formatter@team-tools": true,
    "deployment-tools@team-tools": true,
    "experimental-features@personal": false
  }
}
```

各スコープは異なる目的を果たします:

* **User settings**: 個人的なプラグイン設定
* **Project settings**: リポジトリ内のすべてのユーザーと共有されるプラグイン
* **Local settings**: マシンごとのオーバーライド。Claude Code がそこに設定を保存するときに gitignored
* **Managed settings**: 組織全体のポリシー。ここで `false` に設定されたプラグインはすべてのスコープでインストールがブロックされ、マーケットプレイスから非表示になります

プロジェクト設定はユーザー設定より優先されるため、`~/.claude/settings.json` でプラグインを `false` に設定しても、プロジェクトの `.claude/settings.json` が有効にするプラグインは無効になりません。マシン上でプロジェクト有効プラグインをオプトアウトするには、代わりに `.claude/settings.local.json` で `false` に設定してください。マネージド設定で強制的に有効にされたプラグインは、マネージド設定がローカル設定をオーバーライドするため、この方法では無効にできません。

外部ソース（GitHub リポジトリや npm パッケージなど）からのプラグインをプロジェクトの `.claude/settings.json` で有効にしても、他のユーザーにはインストールされません。プラグインを読み込むすべてのパスで、Claude Code はプラグインがインストールされていないと報告します。各ユーザーが [それ自体をインストール](/docs/ja/plugins/org#require-plugins-per-repository)するまで。

<h3 id="extraknownmarketplaces">
  `extraKnownMarketplaces`
</h3>

追加のプラグインマーケットプレイスを名前で登録して、リポジトリを開く人、またはマネージド設定が到達するすべての人が、自分で追加することなくマーケットプレイスを取得できるようにします。Claude Code は、既に知らないマーケットプレイスを登録します。[`enabledPlugins`](#enabledplugins) がそれから名前を付けるプラグインがインストールされるかどうかは、プラグインのソースとどのファイルがそれを有効にするかに依存します。そのエントリにはルールがあります。

* **Scope**: [`Any file`](#scopes)。Claude Code はリポジトリの `.claude/settings.json` または `.claude/settings.local.json` のエントリを、そのフォルダーのワークスペース信頼ダイアログを受け入れた後にのみ受け入れます。信頼していないフォルダー（`-p` 実行を含む）では、メッセージなしで無視します。
* **Type**: マーケットプレイス名を `source` オブジェクトとオプションの `autoUpdate` Boolean を持つオブジェクトにマッピングするオブジェクト
* **Default**: 未設定

この例は GitHub マーケットプレイスと自己ホストされた git URL からのマーケットプレイスを登録します:

```json settings.json theme={null}
{
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": {
        "source": "github",
        "repo": "acme-corp/claude-plugins"
      }
    },
    "security-plugins": {
      "source": {
        "source": "git",
        "url": "https://git.example.com/security/plugins.git"
      }
    }
  }
}
```

[フォルダーを信頼する前に実行されるもの](/docs/ja/permissions#what-runs-before-you-trust-a-folder)は信頼ゲートとリポジトリが提供できる他のコンテンツを比較します。このキーを `additionalMarketplaces` として書くこともできます。[マーケットプレイスキーエイリアス](#marketplace-key-aliases)を参照してください。

`source` と共に `"autoUpdate": true` を設定して、Claude Code がスタートアップ後にバックグラウンドでそのマーケットプレイスをリフレッシュし、インストールされたプラグインを更新するようにします。省略すると、`claude-plugins-official` およびほとんどの他の公式 Anthropic マーケットプレイスはデフォルトで `true`、サードパーティマーケットプレイスはデフォルトで `false` です。[自動更新を構成する](/docs/ja/plugins/install#keep-plugins-updated)を参照してください。

複数の設定ファイルが同じ名前の下でマーケットプレイスエントリを定義する場合、Claude Code は[最高優先度ファイル](/docs/ja/settings#settings-precedence)からのエントリ全体を使用します。そのエントリは低優先度エントリを置き換え、そのフィールドを継承しないため、再定義は 1 つのファイルの `source.headers` 認証情報を別のファイルが制御する URL と組み合わせることはできません。v2.1.228 より前では、Claude Code は同じ名前のエントリをフィールドごとにマージしたため、より高い優先度ファイルのエントリは、設定しなかったフィールド（別のファイルの `headers` を含む）を継承できました。

<h4 id="marketplace-source-types">
  マーケットプレイスソースタイプ
</h4>

`source` オブジェクトは次のいずれかの形式を取ります:

* **`github`**: GitHub リポジトリ、`repo` を使用
* **`git`**: 任意の git URL、`url` を使用
* **`url`**: `marketplace.json` ファイルへの直接 URL、`url` とオプションの `headers` および `headersHelper` を使用して認証アクセスします。`headersHelper` は値が短命すぎてリストできないヘッダーを出力するコマンドに名前を付け、Claude Code v2.1.238 以降が必要です
* **`file`**: `marketplace.json` ファイルへのローカルパス、`path` を使用
* **`directory`**: ローカルファイルシステムパス、`path` を使用。開発用、または組織が[各マシンにデプロイするマーケットプレイス](/docs/ja/plugins/mods/admin#install-your-organizations-mods)に使用します。
* **`settings`**: ホストされたリポジトリなしで設定ファイルに直接宣言されたインラインマーケットプレイス、`name` および `plugins` を使用

`git` ソースタイプは、自己ホストされた GitLab や Bitbucket を含む任意の git ホスティングサービスで機能します。Claude Code はそのマシンで `git clone` が使用するのと同じ認証でリポジトリをクローンします。設定された認証ヘルパーまたは SSH キー。`GITHUB_TOKEN` などのプロバイダートークンは、それを読む認証ヘルパーを通じてのみ有効になります。セットアップの詳細については、[プライベートリポジトリ](/docs/ja/plugins/host-marketplace#grant-access-to-a-private-marketplace)を参照してください。

`github` および `git` ソースの場合、Claude Code はマーケットプレイスリポジトリをクローンして追加または更新するときに [Git LFS](https://git-lfs.com) コンテンツをダウンロードしません。LFS トラッキングファイルはポインターファイルとしてチェックアウトされ、追加または更新出力はいくつかのレポートを報告します。

`source` オブジェクト内の `skipLfs` フィールドは受け入れられ、効果がありません。v2.1.274 より前では、Claude Code は `"skipLfs": true` を設定しない限り LFS コンテンツをダウンロードしました。

URL ソースの場合、`headers` の認証情報が期限切れになり、コマンドが新しい認証情報を生成する必要がある場合は、`source` オブジェクト内に `headersHelper` を設定します。Claude Code v2.1.238 以降が必要です。コマンドが出力する必要があるもの、および Claude Code がそれを実行する場所については、[headersHelper コマンドを書く](/docs/ja/plugins/host-marketplace#write-the-headershelper-command)を参照してください。Claude Code が headersHelper コマンドをスキップするか、その出力をドロップする場合については、[Claude Code が headersHelper コマンドをスキップするか、その出力をドロップする場合](/docs/ja/plugins/host-marketplace#when-claude-code-skips-a-headershelper-command-or-drops-its-output)を参照してください。`https://` マーケットプレイス URL に `headersHelper` を設定すると、Claude Code は 2 つのポイントでコマンドを実行し、1 回の実行の出力を最大 60 秒間再利用します:

* そのマーケットプレイスの `marketplace.json` の各フェッチの前（後続のリフレッシュを含む）。Claude Code はそのフェッチで出力されたヘッダーを送信します。
* マーケットプレイス URL のオリジン上の各プラグインアーカイブダウンロードの前。つまり、同じスキーム、ホスト、ポート。Claude Code はそのダウンロードで出力を送信し、他のダウンロードはヘッダーを取得しません。

Claude Code は、[`--add-dir`](/docs/ja/permissions#what-runs-before-you-trust-a-folder) で追加するディレクトリの `.claude/settings.json` または `.claude/settings.local.json` に設定された `headersHelper` を無視します。`url` ソースおよびインラインプラグインエントリの両方で、そのファイルに設定された固定 `headers` のみを送信します。[ユーザーが headersHelper コマンドを受け入れる方法](/docs/ja/plugins/host-marketplace#how-users-accept-a-headershelper-command)は他の設定ファイルをカバーしています。

`settings` ソースにリストされたプラグインは、GitHub や npm などの外部ソースを参照する必要があり、`name` はマーケットプレイスキーと一致する必要があります。各プラグインを `enabledPlugins` で個別に有効にする必要があります。この例は 1 つのプラグインをインラインで宣言します:

```json settings.json theme={null}
{
  "extraKnownMarketplaces": {
    "team-tools": {
      "source": {
        "source": "settings",
        "name": "team-tools",
        "plugins": [
          {
            "name": "code-formatter",
            "source": {
              "source": "github",
              "repo": "acme-corp/code-formatter"
            }
          }
        ]
      }
    }
  }
}
```

独自の `source` が [`archive`](/docs/ja/plugins/marketplace-reference#archive-plugin-source) である `source: 'settings'` の下のプラグインエントリは、アーカイブダウンロード用に `headers` を設定できます。`headers` に入れる値が短命の場合（レジストリがリクエストで作成するトークンなど）、代わりに `headersHelper` コマンドを設定します。エントリは両方を設定できます。両方のフィールドには Claude Code v2.1.238 以降が必要です。

Claude Code はエントリの `headers` と、コマンドが出力するもの、そのプラグインのアーカイブダウンロードで送信し、他のダウンロードでは送信しません。Claude Code はユーザーが [そのプラグイン 1 つをインストールまたは更新する](/docs/ja/plugins/host-marketplace#how-users-accept-a-headershelper-command)場合にのみコマンドを実行します。3 つのさらなるルールはエントリを保持するファイルに依存します:

* **`strict`**: マーケットプレイスの `marketplace.json` のエントリとは異なり、設定ファイルのエントリはマニフェストフィールドをインラインする必要がないため、`"strict": false` は必要ありません。[厳密モード](/docs/ja/plugins/marketplace-reference#strict-mode)を参照してください。
* **Folder trust**: プロジェクトの `.claude/settings.json` または `.claude/settings.local.json` のエントリの場合、Claude Code はユーザーが [そのフォルダーも信頼した](/docs/ja/permissions#what-runs-before-you-trust-a-folder)場合にのみコマンドを実行します。
* **Header filter**: Claude Code は、リポジトリがこれらのファイルを提供できるため、プロジェクトの `.claude/settings.json` または `.claude/settings.local.json` のエントリから [リクエストルーティングおよびクライアント ID ヘッダー名](/docs/ja/plugins/host-marketplace#when-claude-code-skips-a-headershelper-command-or-drops-its-output)をドロップします。Claude Code はカタログエントリおよび `--add-dir` ディレクトリの設定のエントリに同じフィルターを適用し、ユーザー設定、`--settings` ファイル、またはマネージド設定のエントリにはフィルターを適用しません。

<h4 id="marketplace-key-aliases">
  マーケットプレイスキーエイリアス
</h4>

Claude Code v2.1.232 以降では、`extraKnownMarketplaces` を `additionalMarketplaces` として、`strictKnownMarketplaces` を `allowedMarketplaces` として書くことができます。Claude Code は各エイリアスを次のように扱います:

* 以前のバージョンはエイリアスを無視するため、マネージド設定ファイルなど、古いバージョンも読む設定ファイルで正規のスペリングを保持してください。
* 正規キーを受け入れる任意の設定ファイルで、Claude Code はエイリアスを正規キーと同じように読みます。
* Claude Code はファイルを更新するときに `additionalMarketplaces` を `extraKnownMarketplaces` に書き直す可能性があります。
* 1 つのファイルで両方のスペリングを設定する場合、Claude Code は正規値を使用し、エイリアスを無視します。

<h3 id="pluginconfigs">
  `pluginConfigs`
</h3>

プラグインの [`userConfig`](/docs/ja/plugins/manifest-reference#user-configuration) 設定ダイアログに与える非機密の回答を、プラグイン ID でキー付けして保存します。Claude Code は、ダイアログに入力するときにこのキーをユーザー設定に書き込むため、手動で編集する必要はありません。Claude Code は機密オプションを macOS Keychain に保存し、Keychain が書き込みを拒否する場合は `~/.claude/.credentials.json` にフォールバックします。サポートされているキーチェーンのないプラットフォームでは、`~/.claude/.credentials.json` に保存します。

* **Scope**: [`User or managed`](#scopes)
* **Type**: プラグイン ID を `options` フィールドを持つオブジェクトにマッピングするオブジェクト。各オプション名を文字列、数値、Boolean、または文字列の配列にマッピングし、オプションの `mcpServers` フィールドは同じ形状でサーバーごとのユーザー設定値を保持します
* **Default**: 未設定

この例は `acme-tools` からの `deployer` プラグインの `api_endpoint` オプションを保存します:

```json settings.json theme={null}
{
  "pluginConfigs": {
    "deployer@acme-tools": {
      "options": {
        "api_endpoint": "https://api.example.com"
      }
    }
  }
}
```

組み込みプラグインは、`@builtin` サフィックス付きで同じキーの下にオプションを保存します。たとえば、Claude Code が `AGENTS.md` ファイルを読み込むかどうかを制御する [**Project instructions**](/docs/ja/memory#choose-which-instruction-files-load) 設定は `pluginConfigs["cc-plugin-agents-md@builtin"].options.instructionFiles` です。v2.1.285 より前では、このプラグインの ID は `agents-md@builtin` でした。それ以降のバージョンは、どちらの ID の下のエントリも読み込みます。

Claude Code はプロジェクトおよびローカルエントリを無視します。これらの値をプラグインフック、MCP、および LSP 設定に置き換えるため、クローンされたリポジトリはそれらを提供できません。v2.1.207 より前では、プロジェクトおよびローカル設定も読まれていました。

<h3 id="prependplugins">
  `prependPlugins`
</h3>

マネージドプラグインのリストで、その [mods](/docs/ja/plugins/mods/overview) がユーザーがインストールするすべての mod の前に実行されます。リストされた順序で実行されます。マネージド設定でこのキーを設定する場合、リストに `sec-default@builtin` を名前付けして、組み込みガードを保持します。マネージド設定では、Claude Code はプラグインが組織のものとしてカウントされないプラグインの ID をスキップします。[組織の mod をインストールして順序を設定する](/docs/ja/plugins/mods/admin#install-your-organizations-mods)を参照してください。これらの条件と 2 つの順序付けキーがどのように機能するかについて。

* **Scope**: [`User or managed`](#scopes)。Claude Code はマネージド設定からキーを読みます。マネージド設定のないマシン上でのみ、Team または Enterprise プランでサインインしていないユーザーのユーザー設定からキーを読みます。プロジェクトおよびローカル設定、および `--settings` ファイルのキーを無視します。
* **Type**: `plugin-name@marketplace-name` 文字列の配列
* **Default**: 未設定

```json managed-settings.json theme={null}
{
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": { "source": "directory", "path": "/opt/acme/claude-plugins" }
    }
  },
  "enabledPlugins": { "acme-guard@acme-tools": true },
  "prependPlugins": ["acme-guard@acme-tools", "sec-default@builtin"]
}
```

<h3 id="appendplugins">
  `appendPlugins`
</h3>

マネージドプラグインのリストで、その [mods](/docs/ja/plugins/mods/overview) がユーザーがインストールするすべての mod の後に実行されます。リストされた順序で実行されます。`prependPlugins` と `appendPlugins` の両方にリストされている ID は、前置されます。マネージド設定では、Claude Code はプラグインが [組織のものとしてカウント](/docs/ja/plugins/mods/admin#install-your-organizations-mods)されないプラグインの ID をスキップします。

* **Scope**: [`User or managed`](#scopes)。Claude Code はマネージド設定からキーを読みます。マネージド設定のないマシン上でのみ、Team または Enterprise プランでサインインしていないユーザーのユーザー設定からキーを読みます。プロジェクトおよびローカル設定、および `--settings` ファイルのキーを無視します。
* **Type**: `plugin-name@marketplace-name` 文字列の配列
* **Default**: 未設定

```json managed-settings.json theme={null}
{
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": { "source": "directory", "path": "/opt/acme/claude-plugins" }
    }
  },
  "enabledPlugins": { "acme-audit@acme-tools": true },
  "appendPlugins": ["acme-audit@acme-tools"]
}
```

<h2 id="mcp">
  MCP
</h2>

Claude Code が接続する MCP サーバーと、組織が許可する MCP サーバーを制御します。[MCP で外部ツールに接続する](/docs/ja/mcp)と[管理対象 MCP 設定](/docs/ja/managed-mcp)を参照してください。

<h3 id="allowallclaudeaimcps">
  `allowAllClaudeAiMcps`
</h3>

Claude Code が自身で取得する[claude.ai コネクタ](/docs/ja/mcp#use-mcp-servers-from-claude-ai)を、デプロイされた `managed-mcp.json` と一緒に読み込みます。このキーがない場合、`managed-mcp.json` は MCP サーバーを排他的に制御し、これらのコネクタを抑制します。

* **スコープ**: [`Managed`](#scopes)。ユーザーは排他的制御によって抑制されたコネクタを再度有効にすることはできません。
* **タイプ**: ブール値
  * `true`: Claude Code は、デプロイされた `managed-mcp.json` と一緒に claude.ai コネクタを読み込みます
  * `false`: デプロイされた `managed-mcp.json` は MCP サーバーを排他的に制御し、Claude Code が自身で取得する[claude.ai コネクタ](/docs/ja/mcp#how-connectors-reach-claude-code)を抑制します
* **デフォルト**: `false`。デプロイされた `managed-mcp.json` は Claude Code が自身で取得する claude.ai コネクタを抑制します

```json managed-settings.json theme={null}
{
  "allowAllClaudeAiMcps": true
}
```

[`allowedMcpServers`](#allowedmcpservers)と[`deniedMcpServers`](#deniedmcpservers)は、このキーが読み込むコネクタにも適用されます。`managed-mcp.json` を持つホスト（自己ホスト型ランナーなど）の[クラウドセッション](/docs/ja/claude-code-on-the-web)に配信されるコネクタは、抑制されたままです。[管理対象セットと一緒に claude.ai コネクタを許可する](/docs/ja/managed-mcp#allow-claude-ai-connectors-alongside-the-managed-set)を参照してください。

<h3 id="allowclaudeinchromewithmanagedmcp">
  `allowClaudeInChromeWithManagedMcp`
</h3>

デプロイされた `managed-mcp.json` と一緒に、組み込みの[Claude in Chrome](/docs/ja/chrome)サーバーを実行できるようにします。このキーがない場合、デプロイされた `managed-mcp.json` はターミナルセッションで Claude in Chrome をブロックします。Claude Code v2.1.282 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。デバイス自身の管理設定からのみ。MDM でデプロイされた plist または HKLM レジストリキー、またはシステム `managed-settings.json` ファイル。Claude Code はサーバー管理設定、ユーザー書き込み可能な HKCU レジストリ、およびユーザーまたはプロジェクト設定では無視します。
* **タイプ**: ブール値
  * `true`: 組み込みの Claude in Chrome サーバーは、デプロイされた `managed-mcp.json` と一緒に実行できます
  * `false`: デプロイされた `managed-mcp.json` はターミナルセッションで Claude in Chrome をブロックします
* **デフォルト**: `false`。デプロイされた `managed-mcp.json` はターミナルセッションで Claude in Chrome をブロックします

```json managed-settings.json theme={null}
{
  "allowClaudeInChromeWithManagedMcp": true
}
```

`claude-in-chrome` の[`deniedMcpServers`](#deniedmcpservers)エントリは、このキーがオンの場合でもサーバーをブロックします。[管理対象セットと一緒に Claude in Chrome を許可する](/docs/ja/managed-mcp#allow-claude-in-chrome-alongside-the-managed-set)を参照してください。

<h3 id="allowedmcpservers">
  `allowedMcpServers`
</h3>

ユーザーが追加できる MCP サーバーをホワイトリストに登録します。Claude Code は、プラグインサーバー、`--mcp-config` で渡されたサーバー、claude.ai からのサーバーを含め、どこで定義されていても、エントリに一致しないサーバーをブロックします。

Claude in Chrome、実行中の[VS Code](/docs/ja/vs-code#the-built-in-ide-mcp-server)または[JetBrains](/docs/ja/jetbrains#the-built-in-ide-mcp-server) IDE に Claude Code が接続する `ide` サーバー、CLI 自体が設定するサーバーなどの組み込みサーバーは、ホワイトリストから除外され、デニーリストは引き続きこれらに適用されます。Claude Code v2.1.268 以降では、[Claude Tag](/docs/ja/claude-tag)セッションの Slack ツールもホワイトリストから除外され、デニーリストは引き続きこれらに適用されます。インプロセス `type: "sdk"` サーバーは両方のリストから除外されます。[セッションを開始したアプリ](/docs/ja/mcp#how-connectors-reach-claude-code)がこれらを登録します。

組織が配信するサーバーもホワイトリストから除外され、デニーリストは引き続きこれらに適用されます。この除外は、すべての[`managedMcpServers`](#managedmcpservers)エントリと、`${VAR}` 展開を使用しない値を持つ[`managed-mcp.json`](/docs/ja/managed-mcp#exclusive-control-with-managed-mcp-json)エントリをカバーします。完全なチェック順序については、[サーバーの評価方法](/docs/ja/managed-mcp#how-a-server-is-evaluated)を参照してください。v2.1.259 より前では、`managed-mcp.json` からのサーバーも一致する必要がありました。

* **スコープ**: [`Any file`](#scopes)。[`allowManagedMcpServersOnly`](#allowmanagedmcpserversonly)が設定されていない限り、すべてのファイルからのエントリが 1 つのホワイトリストにマージされます。管理設定にデプロイして、これを強制します。
* **タイプ**: オブジェクトの配列。各オブジェクトは正確に 1 つのキーを持ちます。`serverName` は、文字、数字、ハイフン、アンダースコアに限定された文字列です。`serverCommand` は、コマンドとその引数を正確に一致させた配列です。または `serverUrl` は、`*` ワイルドカードを含む URL パターンです
* **デフォルト**: 未設定。すべてのサーバーが許可されます。空の配列は、ユーザーが追加するすべてのサーバーをブロックします

この例は、リストされた `npx` コマンドが開始する stdio サーバーのみを許可します。

```json settings.json theme={null}
{
  "allowedMcpServers": [
    { "serverCommand": ["npx", "-y", "@modelcontextprotocol/server-filesystem"] }
  ]
}
```

[`deniedMcpServers`](#deniedmcpservers)エントリが優先されるため、両方のリストにあるサーバーはブロックされます。リストに `serverCommand` エントリが含まれると、stdio サーバーは `serverCommand` エントリと一致する必要があり、`serverUrl` エントリが含まれると、リモートサーバーは `serverUrl` エントリと一致する必要があります。`serverName` の一致は、その種類のサーバーをもはや許可しません。[ホワイトリストとデニーリストを使用したポリシーベースの制御](/docs/ja/managed-mcp#policy-based-control-with-allowlists-and-denylists)を参照してください。

<h3 id="allowmanagedmcpserversonly">
  `allowManagedMcpServersOnly`
</h3>

管理対象ホワイトリストのみを適用対象にします。Claude Code は、ユーザー、プロジェクト、ローカル設定の `allowedMcpServers` を無視し、管理設定からのみ [`allowedMcpServers`](#allowedmcpservers) を読み込みます。[`deniedMcpServers`](#deniedmcpservers)は引き続きすべての設定スコープからマージされるため、ユーザーは自分自身のためにサーバーをブロックできます。管理者は、ユーザー自身の設定が管理対象ホワイトリストが許可するものを拡大できないようにするために、これを設定します。

* **スコープ**: [`Managed`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は管理設定からのみ `allowedMcpServers` を読み込み、ユーザー、プロジェクト、ローカル設定のホワイトリストを無視します
  * `false`: すべての設定スコープのホワイトリストがマージされます
* **デフォルト**: `false`。すべての設定スコープのホワイトリストがマージされます

この例は、ホワイトリストを管理設定にロックし、`github` という名前のサーバーのみを許可します。

```json managed-settings.json theme={null}
{
  "allowManagedMcpServersOnly": true,
  "allowedMcpServers": [
    { "serverName": "github" }
  ]
}
```

ユーザーは引き続き独自の MCP サーバーを追加できます。管理対象ホワイトリストと一致するサーバーのみが読み込まれます。[ホワイトリストを管理設定のみに制限する](/docs/ja/managed-mcp#restrict-the-allowlist-to-managed-settings-only)を参照してください。

<h3 id="deniedmcpservers">
  `deniedMcpServers`
</h3>

特定の MCP サーバーをブロックします。Claude Code は、プラグインサーバー、`--mcp-config` で渡されたサーバー、`managed-mcp.json` からのサーバー、[`managedMcpServers`](#managedmcpservers)からのサーバー、および[自身で取得する](/docs/ja/mcp#how-connectors-reach-claude-code)claude.ai コネクタを含め、どこで定義されていても、一致するサーバーの読み込みを拒否します。インプロセス `type: "sdk"` サーバーは除外されます。セッションを開始したアプリがこれらを登録します。

* **スコープ**: [`Any file`](#scopes)。すべてのファイルからのエントリが 1 つのデニーリストにマージされ、[`allowManagedMcpServersOnly`](#allowmanagedmcpserversonly)はこれを変更しません。管理設定にデプロイして、これを強制します。
* **タイプ**: オブジェクトの配列。各オブジェクトは正確に 1 つのキーを持ちます。`serverName` は文字列です。`"claude.ai Slack"` などの claude.ai コネクタの表示名が機能します。`serverCommand` は、コマンドとその引数を正確に一致させた配列です。または `serverUrl` は、`*` ワイルドカードを含む URL パターンです
* **デフォルト**: 未設定。サーバーはブロックされません。空の配列も何もブロックしません

```json settings.json theme={null}
{
  "deniedMcpServers": [
    { "serverName": "filesystem" }
  ]
}
```

デニーリストは[`allowedMcpServers`](#allowedmcpservers)より優先されるため、両方のリストにあるサーバーはブロックされます。[ホワイトリストとデニーリストを使用したポリシーベースの制御](/docs/ja/managed-mcp#policy-based-control-with-allowlists-and-denylists)を参照してください。

<h3 id="disableclaudeaiconnectors">
  `disableClaudeAiConnectors`
</h3>

[Claude Code が自身で取得する](/docs/ja/mcp#how-connectors-reach-claude-code)[claude.ai MCP コネクタ](/docs/ja/mcp#use-mcp-servers-from-claude-ai)をオフにして、取得も接続もしません。任意の設定ファイルで `true` が適用されます。チェックインされたプロジェクト `.claude/settings.json` はリポジトリをこれらのコネクタから除外できますが、プロジェクトレベルの `false` はユーザーレベルまたは管理レベルの `true` をオーバーライドできません。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code はこれらのコネクタを取得も接続もしません
  * `false`: 未設定と同じです。別の設定ファイルまたは `ENABLE_CLAUDEAI_MCP_SERVERS` がこれらをオフにしない限り、Claude Code はコネクタを取得します
* **デフォルト**: `false`。Claude Code はコネクタを取得します
* **セッションごとのオーバーライド**: [`ENABLE_CLAUDEAI_MCP_SERVERS`](/docs/ja/env-vars)を `false` に設定すると、1 つのセッションのコネクタがオフになります。2 つのうちどちらがオフにしても、もう一方はオンに戻すことはできません

```json settings.json theme={null}
{
  "disableClaudeAiConnectors": true
}
```

`--mcp-config` で明示的に渡すサーバーは影響を受けません。すべてのコネクタをブロックする代わりに個別のコネクタをブロックするには、[`deniedMcpServers`](#deniedmcpservers)を使用します。[claude.ai コネクタを無効にする](/docs/ja/mcp#disable-claude-ai-connectors)を参照してください。

<h3 id="disabledmcpjsonservers">
  `disabledMcpjsonServers`
</h3>

プロジェクトの `.mcp.json` ファイルで定義された特定のサーバーを拒否して、Claude Code がこれらに接続したり、承認を求めたりしないようにします。任意の設定ファイルでの拒否が適用されます。リポジトリにチェックインされたプロジェクト `.claude/settings.json` を含みます。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列の配列。`.mcp.json` に表示されるサーバー名
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "disabledMcpjsonServers": ["filesystem"]
}
```

Claude Code は、承認ダイアログでサーバーを拒否すると、このキーを `.claude/settings.local.json` に書き込みます。`claude mcp get <name>` は、拒否されたサーバーを `✘ Rejected (see disabledMcpjsonServers in settings)` として表示します。拒否は[`enabledMcpjsonServers`](#enabledmcpjsonservers)と[`enableAllProjectMcpServers`](#enableallprojectmcpservers)より優先されます。

<h3 id="enableallprojectmcpservers">
  `enableAllProjectMcpServers`
</h3>

プロジェクト `.mcp.json` ファイルで定義されたすべての MCP サーバーをプロンプトなしで承認します。Claude Code は、承認ダイアログですべてのサーバーを承認することを選択すると、このキーを `.claude/settings.local.json` に書き込みます。

* **スコープ**: [`Any file`](#scopes)。信頼ダイアログを受け入れていないフォルダでは、Claude Code はユーザー設定、管理設定、`--settings` からこれを尊重し、共有プロジェクトファイルではセッション内と `claude mcp list` および `claude mcp get` で無視します。[プロジェクトサーバーの承認とワークスペースの信頼](/docs/ja/mcp#project-server-approvals-and-workspace-trust)は、追跡されていない `.claude/settings.local.json` がいつカウントされるかを説明しています。
* **タイプ**: ブール値
  * `true`: Claude Code はプロジェクト `.mcp.json` ファイルで定義されたすべての MCP サーバーをプロンプトなしで承認します
  * `false`: Claude Code は各サーバーの承認を求めます。信頼されたフォルダでは、優先度の高いファイルの `false` は優先度の低いファイルの `true` をオーバーライドします。信頼していないフォルダでは、尊重されるファイルの `true` で十分です
* **デフォルト**: 未設定。Claude Code は各サーバーの承認を求めます

```json settings.json theme={null}
{
  "enableAllProjectMcpServers": true
}
```

[`disabledMcpjsonServers`](#disabledmcpjsonservers)エントリはサーバーを拒否します。

<h3 id="enabledmcpjsonservers">
  `enabledMcpjsonServers`
</h3>

プロジェクト `.mcp.json` ファイルで定義された特定のサーバーを承認して、Claude Code が質問なしにこれらに接続します。Claude Code は、承認ダイアログでサーバーを承認すると、このキーを `.claude/settings.local.json` に書き込みます。

* **スコープ**: [`Any file`](#scopes)。信頼ダイアログを受け入れていないフォルダでは、Claude Code はユーザー設定、管理設定、`--settings` からこれを尊重し、共有プロジェクトファイルではセッション内と `claude mcp list` および `claude mcp get` で無視します。[プロジェクトサーバーの承認とワークスペースの信頼](/docs/ja/mcp#project-server-approvals-and-workspace-trust)は、追跡されていない `.claude/settings.local.json` がいつカウントされるかを説明しています。
* **タイプ**: 文字列の配列。`.mcp.json` に表示されるサーバー名
* **デフォルト**: 未設定

この例は、プロジェクトの `.mcp.json` から `memory` および `github` サーバーを承認します。

```json settings.json theme={null}
{
  "enabledMcpjsonServers": ["memory", "github"]
}
```

[`disabledMcpjsonServers`](#disabledmcpjsonservers)エントリはサーバーを拒否します。

<h3 id="managedmcpservers">
  `managedMcpServers`
</h3>

管理設定からすべてのユーザーにリモート MCP サーバーを提供します。ユーザーは自分たちが追加したサーバーを保持し、提供されたサーバーを編集または削除することはできません。Claude Code v2.1.259 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。Claude Code はユーザー、プロジェクト、ローカル設定でキーを警告とともにドロップし、Claude Desktop アプリのコードタブでサードパーティデプロイメント上で、またはアプリの Cowork セッションで読み込みません。Claude Desktop はこれらのセッションの MCP サーバーを供給してロックします。
* **タイプ**: サーバー名でキー付けされたオブジェクト。各エントリは `http` または `sse` サーバーの `.mcp.json` 形状を持ちます。必須の `https://` `url` と、オプションで `headers`、`oauth`、その他の HTTP および SSE オプション。Claude Code は検証に失敗したエントリをドロップし、[エントリに含まれる内容](/docs/ja/managed-mcp#what-an-entry-can-contain)は条件をリストします
* **デフォルト**: 未設定。管理設定はサーバーを提供しません

この例は、`search` という名前の 1 つの HTTP サーバーを提供します。

```json managed-settings.json theme={null}
{
  "managedMcpServers": {
    "search": {
      "type": "http",
      "url": "https://search.example.com/mcp"
    }
  }
}
```

優先度、提供されたサーバーが `managed-mcp.json` および許可リストと拒否リストとどのように組み合わされるか、およびユーザーが何を見るかについては、[管理設定を通じてサーバーを提供する](/docs/ja/managed-mcp#provide-servers-through-managed-settings)を参照してください。

<h2 id="agents-sessions-and-worktrees">
  エージェント、セッション、worktree
</h2>

デフォルトエージェントを設定し、チームメイトとクロスセッションメッセージングを制御し、worktree を設定します。[サブエージェント](/docs/ja/sub-agents)と [worktree](/docs/ja/worktrees) を参照してください。

<h3 id="agent">
  `agent`
</h3>

メインスレッドを名前付き[サブエージェント](/docs/ja/sub-agents#invoke-subagents-explicitly)として実行し、Claude Code がそのサブエージェントのシステムプロンプト、ツール制限、およびモデルをセッションに適用するようにします。同じキーは `claude agents` からディスパッチするセッションのデフォルトエージェントも設定します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、組み込みまたはカスタムエージェントの名前
* **デフォルト**: 未設定。メインスレッドは Claude Code のデフォルトエージェントとして実行されます
* **セッションごとの上書き**: `--agent` はこのキーより優先され、1 つのセッションに適用されます

```json settings.json theme={null}
{
  "agent": "code-reviewer"
}
```

プラグイン独自の `settings.json` もこのキーを提供できます。[プラグインでデフォルト設定を配布する](/docs/ja/plugins/components#default-settings)を参照してください。

<h3 id="crosssessioninbound">
  `crossSessionInbound`
</h3>

このセッションが[他の Claude Code セッションから到着するメッセージ](/docs/ja/cross-session-messaging#control-inbound-messages)に対して何を行うかを選択します。値が適用されない場合、Claude Code は 2 つのセッションの権限モードクラスからメッセージごとに決定します。Claude Code v2.1.224 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)。プロジェクトまたはローカル値は、管理設定、`--settings` フラグ、またはユーザー設定が提供する値より厳密な場合にのみ適用されます。
* **タイプ**: 文字列、以下のいずれか：
  * `"accept"`: Claude Code はメッセージを Claude に配信します
  * `"hold"`: Claude Code はメッセージの通知を表示しますが、配信しません
  * `"refuse"`: Claude Code はメッセージを破棄します
* **デフォルト**: 未設定。Claude Code はメッセージごとに決定します

```json settings.json theme={null}
{
  "crossSessionInbound": "hold"
}
```

Claude Code は管理設定を最初に読み込み、次に `--settings` フラグ、その後ユーザー設定を読み込み、最初に見つかった値を適用します。`refuse` は `hold` より厳密で、`hold` は `accept` より厳密です。信頼できるソースのいずれもが値を設定しない場合、プロジェクトまたはローカルの `hold` または `refuse` は依然として適用され、メッセージごとのデフォルトを置き換えます。クロスセッションメッセージングを使用するセッションでは、このキーは `/config` に**他のセッションからのメッセージ**として表示され、ユーザー設定に書き込まれます。この行には Claude Code v2.1.232 以降が必要で、`--settings` フラグまたは管理設定がキーを設定している間、Claude Code はそれを非表示にします。

Claude Code は、認識しない値を設定すると[警告](/docs/ja/errors#crosssessioninbound-must-be-one-of-accept-hold-refuse)します。その値がユーザー、プロジェクト、ローカル、または `--settings` ファイルに存在する間、Claude Code は受信メッセージを保留します。優先されるソースが `accept` を設定している場合でも、です。別のソースが設定する `refuse` は依然として適用されます。値を修正または削除して保留をクリアします。

認識しない値が[管理設定](/docs/ja/managed-settings)にある場合、Claude Code は代わりに管理者が修正するまで `refuse` として扱います。v2.1.248 より前では、Claude Code は警告なしに認識しない値を無視していました。

<h3 id="disableagentview">
  `disableAgentView`
</h3>

[バックグラウンドエージェントとエージェントビュー](/docs/ja/agent-view)をオフにします：`claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザー。[管理設定](/docs/ja/managed-settings)で設定して、組織に対して強制します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにします
  * `false`: エージェントビューが利用可能です
* **デフォルト**: 未設定。エージェントビューが利用可能です
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_AGENT_VIEW`](/docs/ja/env-vars) は 1 つのセッションのエージェントビューをオフにします。2 つのいずれかがそれをオフにすると、もう一方はそれをオンに戻すことはできません

```json settings.json theme={null}
{
  "disableAgentView": true
}
```

<h3 id="isolatepeermachines">
  `isolatePeerMachines`
</h3>

Claude の `SendMessage` がこのマシンを超えたセッションの 1 つに到達する前に、明示的な承認を要求します。[クロスマシンメッセージの承認を要求する](/docs/ja/cross-session-messaging#require-approval-for-cross-machine-messages)を参照してください。承認プロンプトは [`bypassPermissions` モード](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)でも表示されます。

* **スコープ**: [`任意のファイル`](#scopes)。任意のスコープからの `true` が適用されるため、チェックインされたプロジェクトファイルは要件をオンにできますがオフにはできません。
* **タイプ**: ブール値
  * `true`: Claude Code は Claude の `SendMessage` がこのマシンを超えたセッションの 1 つに到達する前に承認を求めます
  * `false`: クロスマシンメッセージはプロンプトを表示しません
* **デフォルト**: 未設定。クロスマシンメッセージはプロンプトを表示しません

```json settings.json theme={null}
{
  "isolatePeerMachines": true
}
```

クロスマシン `SendMessage` 承認には Claude Code v2.1.224 以降が必要です。

<h3 id="processwrapper">
  `processWrapper`
</h3>

macOS と Linux では、[Claude Code が開始するバックグラウンドプロセス](/docs/ja/corporate-launcher#what-the-launcher-covers)の前に企業ランチャーコマンドを配置します。Claude Code はランチャーを独自のコマンドラインを追加して実行するため、ランチャーは Claude Code に exec する必要があります。[企業ランチャーの背後で Claude Code を実行する](/docs/ja/corporate-launcher)を参照してランチャーコントラクトを確認してください。Claude Code v2.1.210 以降が必要です。

* **スコープ**: [`ユーザーまたは管理`](#scopes)
* **タイプ**: 文字列、argv プレフィックスとしてのランチャーコマンド（絶対パスとオプション引数など）
* **デフォルト**: 未設定。バックグラウンドプロセスはラップされずに開始されます
* **セッションごとの上書き**: [`CLAUDE_CODE_PROCESS_WRAPPER`](/docs/ja/env-vars) はこのキーより優先され、1 つのセッションに適用されます

```json settings.json theme={null}
{
  "processWrapper": "/opt/corp/launcher --profile claude"
}
```

Claude Code は Windows でランチャーを無視し、すべてのプロセスをラップされずに開始します。Claude Code v2.1.210 以降が必要です。

<h3 id="teammatemode">
  `teammateMode`
</h3>

Claude Code が[エージェントチーム](/docs/ja/agent-teams)のチームメイトを表示する場所を選択します：メインターミナルペイン内、またはターミナルがサポートしている場合は分割ペイン内。[表示モードを選択する](/docs/ja/agent-teams#choose-a-display-mode)を参照してください。

* **スコープ**: [`任意のファイル`](#scopes)。Claude Code は古いバージョンによって `~/.claude.json` に残された値も読み込みます。
* **タイプ**: 文字列、以下のいずれか：
  * `"in-process"`: チームメイトはメインターミナルペイン内で実行されます
  * `"auto"`: tmux 内で実行している場合、または `PATH` に `it2` がある iTerm2 内で実行している場合、または tmux がインストールされている場合は分割ペイン。それ以外の場合はインプロセス
  * `"tmux"`: ターミナルから検出された tmux または iTerm2 を使用して分割ペイン
  * `"iterm2"`: `it2` CLI を通じた iTerm2 ネイティブ分割ペイン
* **デフォルト**: `"in-process"`
* **セッションごとの上書き**: `--teammate-mode` はこのキーより優先され、1 つのセッションに適用されます

```json settings.json theme={null}
{
  "teammateMode": "auto"
}
```

<span id="worktree-settings" />

<h3 id="worktree">
  `worktree`
</h3>

Claude Code が `--worktree`、`EnterWorktree` ツール、および分離されたサブエージェントとバックグラウンドセッションの [git worktree](/docs/ja/worktrees) を作成および管理する方法を設定します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: `baseRef`、`symlinkDirectories`、`sparsePaths`、および `bgIsolation` を含むオブジェクト
* **デフォルト**: 未設定

この例は、現在の `HEAD` から新しい worktree をブランチし、各 worktree に `node_modules` をシンボリックリンクします：

```json settings.json theme={null}
{
  "worktree": {
    "baseRef": "head",
    "symlinkDirectories": ["node_modules"]
  }
}
```

`.env` のような gitignore されたファイルを新しい worktree にコピーするには、設定の代わりに [`.worktreeinclude` ファイル](/docs/ja/worktrees#copy-gitignored-files-into-worktrees)をプロジェクトルートに追加します。

<h3 id="worktree-baseref">
  `worktree.baseRef`
</h3>

新しい worktree がブランチする ref を選択します。`"fresh"` は `origin/<default-branch>` からブランチして、リモートと一致するクリーンツリーを取得します。`"head"` は現在のローカル `HEAD` からブランチするため、プッシュされていないコミットとフィーチャーブランチの状態が worktree に存在します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか：
  * `"fresh"`: 新しい worktree は `origin/<default-branch>` からブランチします
  * `"head"`: 新しい worktree は現在のローカル `HEAD` からブランチします（プッシュされていないコミットを含む）
* **デフォルト**: `"fresh"`

```json settings.json theme={null}
{
  "worktree": {
    "baseRef": "head"
  }
}
```

リンクされた worktree 内では、`"head"` はメインチェックアウトの `HEAD` ではなく、その worktree の `HEAD` に解決されます。

<h3 id="worktree-symlinkdirectories">
  `worktree.symlinkDirectories`
</h3>

メインリポジトリからディレクトリを各 worktree にシンボリックリンクして、ディスク上の大きなディレクトリを複製しないようにします。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列の配列、リポジトリルートに相対的なディレクトリパス
* **デフォルト**: 未設定。Claude Code はディレクトリをシンボリックリンクしません

この例は、メインリポジトリから `node_modules` と `.cache` をすべての新しい worktree にシンボリックリンクします：

```json settings.json theme={null}
{
  "worktree": {
    "symlinkDirectories": ["node_modules", ".cache"]
  }
}
```

<h3 id="worktree-sparsepaths">
  `worktree.sparsePaths`
</h3>

git sparse-checkout を通じて各 worktree にリストされたディレクトリのみをチェックアウトします。Claude Code はそれらのディレクトリとルートレベルのファイルのみをディスクに書き込みます。これは大規模なモノレポでより高速です。[必要なディレクトリのみをチェックアウトする](/docs/ja/large-codebases#check-out-only-the-directories-you-need)を参照してください。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列の配列、リポジトリルートに相対的なディレクトリパス
* **デフォルト**: 未設定。各 worktree はツリー全体をチェックアウトします

この例は、各 worktree で `packages/my-app` と `shared/utils` のみをチェックアウトします（ルートレベルのファイルを含む）：

```json settings.json theme={null}
{
  "worktree": {
    "sparsePaths": ["packages/my-app", "shared/utils"]
  }
}
```

スパース worktree が存在する間、git はリポジトリの共有 `.git/config` で `extensions.worktreeConfig` を有効にします。

<h3 id="worktree-bgisolation">
  `worktree.bgIsolation`
</h3>

[バックグラウンドセッション](/docs/ja/agent-view#how-file-edits-are-isolated)がファイル編集を分離する方法を選択します。`←` または `/background` でセッションをバックグラウンドに移動した場合、このキーの値にかかわらず、そのセッションはファイルをその場で編集します。`"worktree"` では、Claude Code はセッションが `EnterWorktree` を呼び出すまでメインチェックアウトで `Edit` と `Write` をブロックします。`"none"` では、バックグラウンドジョブはワーキングコピーを直接編集します。git worktree が実用的でないリポジトリの場合は `"none"` を設定します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか：
  * `"worktree"`: Claude Code はセッションが `EnterWorktree` を呼び出すまでメインチェックアウトで `Edit` と `Write` をブロックします
  * `"none"`: バックグラウンドジョブはワーキングコピーを直接編集します
* **デフォルト**: `"worktree"`

```json settings.json theme={null}
{
  "worktree": {
    "bgIsolation": "none"
  }
}
```

git リポジトリの外では、失敗する [`WorktreeCreate` フック](/docs/ja/worktrees#non-git-version-control)がブロックを解放し、セッションが作業ディレクトリをその場で編集できるようにします。その解放には Claude Code v2.1.203 以降が必要です。

<h2 id="remote-desktop-and-notifications">
  リモート、デスクトップ、および通知
</h2>

Remote Control、クラウド環境、デスクトップアプリ、および Claude Code が必要な場合に送信する通知を設定します。[Remote Control](/docs/ja/remote-control) を参照してください。

<h3 id="agentpushnotifenabled">
  `agentPushNotifEnabled`
</h3>

Claude が価値があると判断した場合（たとえば、長いタスクが完了した場合など）に、電話にプッシュ通知を送信することを許可します。Claude Code はこの選択をアカウントに同期し、[Remote Control](/docs/ja/remote-control) が接続されている間にプッシュが到着します。`/config` では **Push when Claude decides** として表示されます。

* **Scope**: [`Any file`](#scopes)。Claude Code は古いバージョンによって `~/.claude.json` に残された値も読み取ります。
* **Type**: Boolean
  * `true`: Claude は価値があると判断した場合に電話にプッシュ通知を送信できます
  * `false`: Claude はそれらの通知を送信しません
* **Default**: `false`

```json settings.json theme={null}
{
  "agentPushNotifEnabled": true
}
```

[Mobile push notifications](/docs/ja/remote-control#mobile-push-notifications) を参照してください。

<h3 id="awaysummaryenabled">
  `awaySummaryEnabled`
</h3>

数分間離れた後にターミナルに戻ったときに、1 行のセッション要約を表示します。`false` に設定するか、`/config` で **Session recap** をオフにして、要約を停止します。

* **Scope**: [`Any file`](#scopes)
* **Type**: Boolean
  * `true`: 数分間離れた後に戻ったときに、1 行のセッション要約が表示されます
  * `false`: Claude Code は要約を表示しません
* **Default**: 未設定なので、要約はオンです
* **Per-session overrides**: [`CLAUDE_CODE_ENABLE_AWAY_SUMMARY`](/docs/ja/env-vars) はこのキーより優先され、どちらの方向でも 1 セッションに適用されます

```json settings.json theme={null}
{
  "awaySummaryEnabled": false
}
```

Claude Code は非対話モードでは要約を表示しません。

<h3 id="disableartifact">
  `disableArtifact`
</h3>

<Warning>
  非推奨であり、[`enableArtifact`](#enableartifact) に置き換えられました。Claude Code は `disableArtifact: true` を `enableArtifact: false` と同等として引き続き尊重し、`disableArtifact: false` は無視します。
</Warning>

代わりに [`enableArtifact`](#enableartifact) を使用して、セッション出力を claude.ai 上のプライベート Web ページとして公開する [Artifact](/docs/ja/artifacts) ツールをオフにします。`/config` で **Artifacts** 行をオフにすると、Claude Code はユーザー設定に `enableArtifact` を書き込み、このキーをクリアします。

* **Scope**: [`Any file`](#scopes)
* **Type**: Boolean
  * `true`: Claude Code はファイルが適用されるすべてのセッションに対して Artifact ツールをオフにし、他のファイルはそれをオンに戻しません
  * `false`: 無視されます。ツールをオンのままにするには、キーを削除します
* **Default**: 未設定なので、ツールはアカウントの [availability](/docs/ja/artifacts#availability) に従います
* **Per-session overrides**: [`CLAUDE_CODE_DISABLE_ARTIFACT`](/docs/ja/env-vars) を `1` に設定すると、1 つのセッションのツールがオフになります

```json settings.json theme={null}
{
  "disableArtifact": true
}
```

[Disable artifacts](/docs/ja/artifacts#disable-artifacts) はツールをオフにするすべての方法を一覧表示します。

<h3 id="disabledeeplinkregistration">
  `disableDeepLinkRegistration`
</h3>

Claude Code が `claude-cli://` プロトコルハンドラーをオペレーティングシステムに登録することを停止します。通常、対話セッションの最初のプロンプトを送信した後に登録されます。[Deep links](/docs/ja/deep-links) により、外部ツールは事前入力されたプロンプトで Claude Code セッションを開くことができます。プロトコルハンドラー登録が制限されているか、別途管理されている環境でこれを設定します。

* **Scope**: [`Any file`](#scopes)
* **Type**: 文字列 `"disable"`
* **Default**: 未設定なので、Claude Code はハンドラーを登録します

```json settings.json theme={null}
{
  "disableDeepLinkRegistration": "disable"
}
```

<h3 id="disabledesktoplocalsessions">
  `disableDesktopLocalSessions`
</h3>

開発者が SSH 経由でリモートマシンで作業する必要があるデプロイメント用に、[デスクトップアプリ](/docs/ja/desktop#local-sessions-on-managed-devices) で実行されるコードセッションをオフにします。Code タブでは、**Local** 環境は環境ドロップダウンに留まりますが、グレーアウトされて選択できず、組織がオフにしたことを示すツールチップが表示されます。Windows では WSL エントリも同じようにグレーアウトされますが、WSL セッションがマネージドデバイスで実行されるかどうかは [別途管理されます](/docs/ja/admin-setup#wsl-sessions-in-claude-code-desktop)。新しいセッションは、設定されている場合は最初の [SSH 接続](/docs/ja/desktop#ssh-sessions) にデフォルト設定され、アプリは同じマシンへの SSH 接続を含む、デバイス上のセッションの開始または再開を拒否します。他のホストへの SSH セッションとクラウドセッションは影響を受けません。デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。Claude Desktop v1.37937.0 以降が必要です。

* **Scope**: [`Managed`](#scopes)。デフォルトでは、デスクトップアプリは [1 つの管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) からキーを読み取ります。
* **Type**: Boolean。JSON Boolean `true` のみが有効です
  * `true`: デスクトップアプリはオンデバイスコードセッションを提供しません。既存のローカルセッションはリストに残りますが、続行できません
  * `false`: ローカルセッションは利用可能なままです
* **Default**: 未設定なので、ローカルセッションは利用可能です

```json managed-settings.json theme={null}
{
  "disableDesktopLocalSessions": true
}
```

デスクトップアプリは他の値を無視し、文字列 `"true"` や `1` などの Boolean ではない値も警告をログに記録します。[`sshConfigs`](#sshconfigs) とペアにして、ユーザーが機能する接続にアクセスし、[`sshHostAllowlist`](#sshhostallowlist) とペアにして、到達できるホストを制限します。[Local sessions on managed devices](/docs/ja/desktop#local-sessions-on-managed-devices) を参照してください。

Claude Desktop は、デスクトップ設定から派生したポリシー（たとえば、エグレス許可リスト、ファイルシステムサンドボックス、サードパーティデプロイメント内の MCP 制限など）を使用して Code セッションを提供します。Claude Code は、[管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) が存在する場合（サーバー管理設定、MDM または OS レベルのポリシー、またはマネージド設定ファイル）、常にそれらの親設定を無視します。サードパーティデプロイメントのように、以前にないデバイスにこのキーをデプロイすると、デスクトップ派生ポリシーが適用されなくなります。[Let an embedding host add policy](/docs/ja/managed-settings#let-an-embedding-host-add-policy) は、親設定がまだマージできる場合をカバーしています。これは、このキーだけでなく、その方法でデプロイするすべてのキーに適用されます。

<h3 id="disableremotecontrol">
  `disableRemoteControl`
</h3>

[Remote Control](/docs/ja/remote-control) をオフにします。Claude Code は `claude remote-control`、`--remote-control` フラグ、自動開始、およびセッション内トグルを拒否し、組織のポリシーがそれを無効にしたことを報告します。[マネージド設定](/docs/ja/managed-settings) に配置して、デバイスごとの MDM 強制を行います。

* **Scope**: [`Any file`](#scopes)
* **Type**: Boolean
  * `true`: Claude Code は `claude remote-control`、`--remote-control` フラグ、自動開始、およびセッション内トグルを拒否します
  * `false`: Remote Control は利用可能なままです
* **Default**: `false`

```json settings.json theme={null}
{
  "disableRemoteControl": true
}
```

<h3 id="enableartifact">
  `enableArtifact`
</h3>

セッション出力を claude.ai 上のプライベート Web ページとして公開する [Artifact](/docs/ja/artifacts) ツールをオフにします。`/config` で **Artifacts** 行をオフにすると、Claude Code はこのキーをユーザー設定に書き込むため、通常は手動で編集しません。Claude Code v2.1.196 以降が必要です。

* **Scope**: [`Any file`](#scopes)。すべてのファイルはツールをオフにでき、どのファイルもそれをオンに戻すことはできません。
* **Type**: Boolean
  * `false`: Claude Code はファイルが適用されるすべてのセッションに対して Artifact ツールをオフにします
  * `true`: キーを未設定のままにするのと同じです。別のファイルからの `false`、[`CLAUDE_CODE_DISABLE_ARTIFACT`](/docs/ja/env-vars)、または組織の [管理設定](/docs/ja/artifacts#manage-artifacts-for-your-organization) をオーバーライドしないためです
* **Default**: 未設定なので、ツールはアカウントの [availability](/docs/ja/artifacts#availability) に従います

```json settings.json theme={null}
{
  "enableArtifact": false
}
```

ユーザー設定以外のソースがツールをオフのままにしている間、Claude Code は `/config` で **Artifacts** 行を非表示にします。そこでオンにしても何も変わらないためです。[Disable artifacts](/docs/ja/artifacts#disable-artifacts) はツールをオフにするすべての方法を一覧表示します。

<h3 id="inputneedednotifenabled">
  `inputNeededNotifEnabled`
</h3>

権限プロンプトまたは質問が入力を待っているときに、電話にプッシュ通知を取得します。Claude Code はこれらを [Remote Control](/docs/ja/remote-control) が接続されている間のみ送信します。`/config` では **Push when actions required** として表示されます。

* **Scope**: [`Any file`](#scopes)。Claude Code は古いバージョンによって `~/.claude.json` に残された値も読み取ります。
* **Type**: Boolean
  * `true`: Remote Control が接続されている間、権限プロンプトまたは質問が入力を待っているときに、電話にプッシュ通知が届きます
  * `false`: Claude Code はそのような通知を送信しません
* **Default**: `false`

```json settings.json theme={null}
{
  "inputNeededNotifEnabled": true
}
```

[Mobile push notifications](/docs/ja/remote-control#mobile-push-notifications) を参照してください。

<h3 id="preferrednotifchannel">
  `preferredNotifChannel`
</h3>

タスクが完了したときまたは権限プロンプトが待機しているときに Claude Code が通知する方法を選択します。`/config` では **Local notifications** として表示されます。

* **Scope**: [`Any file`](#scopes)。Claude Code は古いバージョンによって `~/.claude.json` に残された値も読み取ります。
* **Type**: 文字列、以下のいずれか：
  * `"auto"`: Claude Code は iTerm2、Ghostty、Kitty でデスクトップ通知を送信し、Terminal.app でのみ可聴ベルがオフの場合にベルを鳴らし、他の場所では何もしません
  * `"terminal_bell"`: Claude Code は任意のターミナルでベル文字を鳴らします
  * `"iterm2"`: Claude Code は iTerm2 デスクトップ通知を送信します
  * `"iterm2_with_bell"`: Claude Code は iTerm2 デスクトップ通知を送信し、ベルを鳴らします
  * `"kitty"`: Claude Code は Kitty デスクトップ通知を送信します
  * `"ghostty"`: Claude Code は Ghostty デスクトップ通知を送信します
  * `"notifications_disabled"`: Claude Code は通知を送信しません
* **Default**: `"auto"`

```json settings.json theme={null}
{
  "preferredNotifChannel": "terminal_bell"
}
```

`"auto"` では、Claude Code は iTerm2、Ghostty、Kitty でデスクトップ通知を送信します。Terminal.app では、Terminal の可聴ベルをオフにした場合のみベル文字を鳴らし、他のターミナルでは何もしません。任意のターミナルでベル文字を鳴らすには `"terminal_bell"` を設定します。[Get a terminal bell or notification](/docs/ja/terminal-config#get-a-terminal-bell-or-notification) を参照してください。

<h3 id="remote-defaultenvironmentid">
  `remote.defaultEnvironmentId`
</h3>

`claude --cloud` などの CLI から作成するクラウドセッション用のデフォルト [クラウド環境](/docs/ja/cloud-environments) を選択します。Claude Code は [`/remote-env`](/docs/ja/cloud-environments#select-an-environment-from-the-cli) で環境を選択するときに、このキーをユーザー設定に書き込みます。

* **Scope**: [`Any file`](#scopes)。自己ホスト環境 ID の場合、ユーザーまたはマネージド設定、または `--settings` フラグのみ。
* **Type**: 文字列、`env_...` または `ccpool_...` などの環境 ID
* **Default**: 未設定なので、Claude Code はリストに Anthropic ホスト環境がある場合はそれを使用し、そうでない場合は [Remote Control ブリッジ環境](/docs/ja/cloud-environments#the-default-environment) ではないリスト内の最初の環境を使用するか、すべてがブリッジ環境の場合は最初の環境を使用します
* **Per-session overrides**: `--environment` はこのキーより優先され、作成する 1 つのクラウドセッションに適用されます

```json settings.json theme={null}
{
  "remote": {
    "defaultEnvironmentId": "env_0123abcd"
  }
}
```

`env_` で始まる Anthropic ホスト環境 ID は標準設定の優先度に従うため、リポジトリのプロジェクト設定の値がユーザーレベルの選択をオーバーライドします。`ccpool_` で始まる [自己ホスト環境](/docs/ja/self-hosted-environments) ID は、ユーザー設定、マネージド設定、および `--settings` フラグからのみ尊重されます。Claude Code はリポジトリのプロジェクトまたはローカル設定のものを無視し、`/remote-env` は無視した値を表示するため、チェックインされたファイルは選択しなかった自己ホスト環境にセッションをステアリングできません。

<h3 id="remotecontrolatstartup">
  `remoteControlAtStartup`
</h3>

各対話セッションの開始時に [Remote Control](/docs/ja/remote-control) を自動的に接続します。`/remote-control` を待つ代わりに。自動接続をオンにするには `true` に設定し、オフにするには `false` に設定します。`/config` では **Enable Remote Control for all sessions** として表示されます。

* **Scope**: [`Any file`](#scopes)。Claude Code は古いバージョンによって `~/.claude.json` に残された値も読み取ります。
* **Type**: Boolean
  * `true`: Claude Code は各対話セッションの開始時に Remote Control を自動的に接続します
  * `false`: Claude Code は `/remote-control` を待ちます
* **Default**: 未設定なので、[自動接続デフォルト](/docs/ja/remote-control#enable-remote-control-for-all-sessions) が適用されます
* **Per-session overrides**: `--remote-control` はこのキーが `false` の場合でも 1 つのセッションに対して Remote Control をオンにし、フラグは 1 つのセッションに対してそれをオフにしません

```json settings.json theme={null}
{
  "remoteControlAtStartup": true
}
```

Claude Code はプロジェクトまたはローカル設定からの `true` を無視するため、リポジトリはそのチェックアウトの自動接続をオフにできますが、オンにすることはできません。完全なスコープごとの動作については、[Enable Remote Control for all sessions](/docs/ja/remote-control#enable-remote-control-for-all-sessions) および [より厳密な値が適用されるセキュリティキー](/docs/ja/settings#security-keys-where-the-stricter-value-applies) を参照してください。

<h3 id="sshconfigs">
  `sshConfigs`
</h3>

[Desktop](/docs/ja/desktop#pre-configure-ssh-connections-for-your-team) 環境ドロップダウンに SSH 接続を追加します。管理者はこれを使用して、共有接続をチームに配布します。マネージド設定で定義した接続はマネージドとして表示されるため、ユーザーはそれらを選択できますが、アプリで編集または削除することはできません。

* **Scope**: [`User or managed`](#scopes)。デスクトップアプリはこのキーを読み取ります。デフォルトでは、管理対象の接続を [1 つの管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) から読み取ります。
* **Type**: オブジェクトの配列。各オブジェクトは必須の `id`、`name`、`sshHost` と、オプションの `sshPort` および `sshIdentityFile` を持ちます
* **Default**: 未設定

この例は、`user@dev.example.com` に接続する `Dev VM` という名前の 1 つの接続を追加します：

```json settings.json theme={null}
{
  "sshConfigs": [
    {
      "id": "dev-vm",
      "name": "Dev VM",
      "sshHost": "user@dev.example.com"
    }
  ]
}
```

<h3 id="sshhostallowlist">
  `sshHostAllowlist`
</h3>

[Desktop SSH セッション](/docs/ja/desktop#restrict-which-ssh-hosts-users-can-connect-to) が接続できるホストを制限します。デスクトップアプリのみがこのキーを読み取ります。CLI は読み取りません。パターンは大文字と小文字を区別しません。`*` は任意のホストに一致し、`*.example.com` は `example.com` とすべてのサブドメインに一致し、その他は `~/.ssh/config` 解決後のホスト名に対する完全一致です。空の配列は SSH セッションをオフにします。

* **Scope**: [`Managed`](#scopes)。デフォルトでは、Desktop は [1 つの管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) からキーを読み取ります。
* **Type**: ホスト名パターンの配列
* **Default**: 未設定なので、任意のホストが許可されます

この例は、`devboxes.example.com` とそのサブドメイン、および正確なホスト `bastion.example.com` を許可します：

```json managed-settings.json theme={null}
{
  "sshHostAllowlist": ["*.devboxes.example.com", "bastion.example.com"]
}
```

`true` やオブジェクトなど、Desktop がホストのリストとして読み取れない値は、修正するまで空の配列として扱われます。ただし `null` は未設定として扱われます。Claude Desktop v2.26454.0 以降が必要です。

最上位のソースで [`managedSourcesBehavior`](#managedsourcesbehavior) を `"merge"` に設定すると、Desktop はすべての [管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) のリストを結合し、いずれかに一致するホストを許可します。あるソースで空の配列を設定しても、別のソースがリストしているホストに対しては SSH セッションはオンのままです。

<span id="authentication-and-login" />

<h2 id="authentication-and-providers">
  認証とプロバイダー
</h2>

ヘルパースクリプトを通じて認証情報を提供し、組織の場合はログイン方法または組織を強制します。[認証](/docs/ja/authentication)を参照してください。

<h3 id="allowedproviders">
  `allowedProviders`
</h3>

マシンが Claude に到達できるサービス（Anthropic API、Amazon Bedrock、LLM ゲートウェイなど）をリストアップします。リストに記載されていないプロバイダー上のセッションは、スタートアップ時、ログイン時、および次に API に接続するときに拒否されるため、セッション中にリストに記載されていないプロバイダーに切り替えることも拒否されます。[拒否メッセージ](/docs/ja/errors#managed-settings-dont-allow-this-api-provider)には、プロバイダーを選択したものと続行するためのステップが記載されています。Claude Code v2.1.285 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。マシン自身の管理者ソース（MDM ポリシーおよび管理設定ファイル）が設定したリストは、サーバー管理設定もリストを配信する場合でも適用され続けます。その場合、セッションは両方のリスト上のプロバイダーのみを使用できるため、サーバー管理リストはマシンが許可するものを狭めることはできますが、広げることはできません。マシンソースの `allowedProviders` のどれが数えられるかは、[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)に従います。サーバー管理設定のみを通じて配信されたリストは、[サーバー管理設定を取得する](/docs/ja/server-managed-settings#platform-availability)セッションのみに到達します。
* **タイプ**: 文字列の配列。各要素は以下のいずれか：
  * `"anthropic"`: claude.ai または Console サインイン、または API キーを通じた Anthropic 独自のホスト上の Anthropic API。[`forceLoginMethod`](#forceloginmethod) または [`forceLoginOrgUUID`](#forceloginorguuid) と組み合わせてサインインも制限します
  * `"bedrock"`: [Amazon Bedrock](/docs/ja/amazon-bedrock)
  * `"vertex"`: [Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)（旧 Vertex AI）
  * `"foundry"`: [Microsoft Foundry](/docs/ja/microsoft-foundry)
  * `"anthropicAws"`: [AWS 上の Claude Platform](/docs/ja/claude-platform-on-aws)
  * `"mantle"`: Amazon Bedrock [Mantle エンドポイント](/docs/ja/amazon-bedrock#use-the-mantle-endpoint)。[Invoke API と並行して Mantle を実行する](/docs/ja/amazon-bedrock#run-mantle-alongside-the-invoke-api)セッションは両方のプロバイダーを使用するため、`"bedrock"` と `"mantle"` をまとめてリストアップします
  * `"customEndpoint"`: 別のホストに送信される Anthropic API またはクラウドプロバイダーの API。`ANTHROPIC_BASE_URL` や、`ANTHROPIC_BEDROCK_BASE_URL` などのプロバイダーのエンドポイント変数で指定された [LLM ゲートウェイ](/docs/ja/llm-gateway)などです。Claude Code はそれを管理 [`env`](#env) ブロックがピンで留めた正確な値に対してのみ許可します
  * `"gateway"`: [Cloud ゲートウェイ](/docs/ja/claude-apps-gateway)サインイン
* **デフォルト**: 未設定。任意のプロバイダーを使用できます

```json managed-settings.json theme={null}
{
  "allowedProviders": ["anthropic", "bedrock"]
}
```

各クラウドプロバイダーのエントリは、そのプロバイダー独自のサービス（地域、FIPS、プライベートエンドポイントを含む）を意味します。

Claude Code がプロバイダー名として認識しないエントリは削除され、報告され、リストの残りは強制されます。空のリスト、またはすべてのエントリが認識されないリストの場合、Claude Code はすべてのプロバイダーを拒否し、マシン上で起動しません。

<h4 id="endpoints-that-need-a-pin-in-managed-env">
  管理 `env` でピンが必要なエンドポイント
</h4>

ピンは、管理 [`env`](#env) ブロックで設定されたエンドポイント変数の値です。セッションがプロバイダーのトラフィックをそのプロバイダー独自のサービス以外の場所に送信する場合、Claude Code はセッションの値がピンと同じ場合にのみそれを許可します。これらのエンドポイントには 1 つが必要です：

* **`"customEndpoint"` セッション**: ホストを指定する変数（`ANTHROPIC_BASE_URL` など）
* **Amazon Bedrock**: AWS SDK の `AWS_ENDPOINT_URL`、`AWS_ENDPOINT_URL_BEDROCK`、および `AWS_ENDPOINT_URL_BEDROCK_RUNTIME` 変数が Bedrock 独自のサービス外を指す場合。セッションは `"customEndpoint"` ではなく `"bedrock"` の下に留まります
* **ゲートウェイサインイン URL**: セッションは `"gateway"` の下に留まり、[`forceLoginGatewayUrl`](#forcelogingatewayurl) もピンとしてカウントされます

どの `env` ブロックがピンとしてカウントされるかは、リストが設定されている場所によって異なります：

* **マシン上の管理者ソースがリストを設定**: マシン独自の管理者ソースの `env` ブロックのみがカウントされます
* **サーバー管理設定のみがリストを設定**: これらのサーバー管理設定の `env` 値もカウントされます

リストは、クラウドプロバイダーの認証情報とテナンシー変数、または `HTTPS_PROXY` と証明書設定などのネットワークパスを判定しません。管理 `env` ブロックでフリート用にそれらを設定します。

<h3 id="apikeyhelper">
  `apiKeyHelper`
</h3>

Claude Code がモデルリクエストで送信する認証情報を生成するために独自のコマンドを実行します。Claude Code はコマンドをシステムシェル（macOS と Linux では `/bin/sh`、Windows では `cmd`）を通じて実行し、その出力を `X-Api-Key` ヘッダーと `Authorization: Bearer` ヘッダーの両方として送信します。ボールトから取得した短期トークンなど、動的または回転する認証情報に使用します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列、シェルコマンドライン
* **デフォルト**: 未設定。Claude Code はヘルパーを実行しません

```json settings.json theme={null}
{
  "apiKeyHelper": "/bin/generate_temp_api_key.sh"
}
```

Claude Code はこれらの場合に値をキャッシュし、コマンドを再実行します。

* キャッシュの有効期限後。デフォルトは 5 分、または [`CLAUDE_CODE_API_KEY_HELPER_TTL_MS`](/docs/ja/env-vars) で設定した間隔
* Anthropic API へのリクエスト（直接または [LLM ゲートウェイ](/docs/ja/llm-gateway)経由）が `401` または `403` で失敗した場合
* Anthropic API へのリクエスト（直接または LLM ゲートウェイ経由）を送信する前に、キャッシュされた出力がヘルパーが生成した後に期限切れになった JWT である場合。Claude Code v2.1.246 以降が必要です。

最後の 2 つのケースは、ヘルパーの出力が Claude Code が送信する認証情報であり、`ANTHROPIC_AUTH_TOKEN` が設定されていない場合にのみ適用されます。

インタラクティブセッションでは、コマンドがプロジェクトまたはローカル設定から来ている場合、Claude Code はワークスペーストラストプロンプトを受け入れるまでコマンドを実行しません。[認証情報管理](/docs/ja/authentication#credential-management)を参照してください。

<h3 id="awsauthrefresh">
  `awsAuthRefresh`
</h3>

`aws sso login` などの独自のコマンドを実行して、Claude Code が [Amazon Bedrock](/docs/ja/amazon-bedrock) に対して持つ認証情報が機能しなくなったときに `.aws` ディレクトリの認証情報をリフレッシュします。Claude Code は最初に現在の認証情報を STS に対してチェックし、そのチェックが失敗した場合にのみコマンドを実行してから、リフレッシュされた `.aws` ディレクトリを読み取ります。

同じコマンドと認証情報を使用する複数の Claude Code プロセス（別々のターミナルや IDE ウィンドウなど）で同時にチェックが失敗した場合、1 つのプロセスがコマンドを実行し、残りのプロセスは独自に実行を開始する代わりにその実行を待機します。リクエストを保留したまま 60 秒間待機したプロセスは、自らコマンドを実行します。この動作をオフにするには、[`CLAUDE_CODE_DISABLE_AUTH_REFRESH_LOCK`](/docs/ja/env-vars) を `1` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列、シェルコマンドライン
* **デフォルト**: 未設定。Claude Code は AWS 認証情報をリフレッシュしません

```json settings.json theme={null}
{
  "awsAuthRefresh": "aws sso login --profile myprofile"
}
```

リフレッシュフローが `.aws` に書き込む場合はこのキーを使用します。代わりに認証情報を出力する場合は [`awsCredentialExport`](#awscredentialexport) を使用します。[高度な認証情報設定](/docs/ja/amazon-bedrock#advanced-credential-configuration)を参照してください。

<h3 id="awscredentialexport">
  `awsCredentialExport`
</h3>

AWS 認証情報を JSON として出力する独自のコマンドを実行して、Claude Code が `.aws` ディレクトリに存在しない認証情報で [Amazon Bedrock](/docs/ja/amazon-bedrock) を呼び出すことができるようにします。Claude Code は `aws sts` 出力形式とフラットな `aws configure export-credentials` 形式を受け入れ、認証情報を独自の Bedrock クライアントにスコープするため、Claude Code が実行するシェルコマンドは引き続き環境の認証情報を参照します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列、シェルコマンドライン
* **デフォルト**: 未設定。Claude Code は環境の AWS 認証情報チェーンを使用します

```json settings.json theme={null}
{
  "awsCredentialExport": "/bin/generate_aws_grant.sh"
}
```

[`awsAuthRefresh`](#awsauthrefresh) とは異なり、Claude Code はこのコマンドが設定されている場合、環境の認証情報を最初にチェックせずに常に実行します。[高度な認証情報設定](/docs/ja/amazon-bedrock#advanced-credential-configuration)を参照してください。

<h3 id="forceloginmethod">
  `forceLoginMethod`
</h3>

ユーザーがログインできるアカウントの種類を制限します。`"claudeai"` を設定して claude.ai アカウントのみを許可するか、`"console"` を設定して Claude Console アカウントのみを許可するか、`"gateway"` を設定してファーストパーティログインの代わりに [クラウドゲートウェイ](/docs/ja/claude-apps-gateway)にユーザーを送信します。管理者は管理設定で設定し、[`forceLoginOrgUUID`](#forceloginorguuid) と組み合わせて開発者の claude.ai ログインを 1 つの組織内に保つことができます。任意の設定ファイルで `"claudeai"` または `"console"` に設定した場合、Claude Code はそのファイルが適用されるセッションで [キーレス Console サインイン](/docs/ja/authentication#sign-in-without-an-api-key)の提供も停止します。

* **スコープ**: [`Any file`](#scopes)。Claude Code は `"gateway"` をマシン上の管理ソース（`managed-settings.json`、macOS plist または Windows HKLM レジストリ、またはポリシーヘルパー）からのみ受け入れます。ユーザー、プロジェクト、ローカル、HKCU、およびサーバー管理設定では `"gateway"` を未設定として扱います。これは [`forceLoginGatewayUrl`](#forcelogingatewayurl) と同じルールです。
* **タイプ**: 文字列、以下のいずれか：
  * `"claudeai"`: claude.ai アカウントのみがログインできます
  * `"console"`: Claude Console アカウントのみがログインできます
  * `"gateway"`: Claude Code はユーザーをファーストパーティログインの代わりにクラウドゲートウェイに送信します
* **デフォルト**: 未設定。ユーザーはログイン方法を選択します

```json settings.json theme={null}
{
  "forceLoginMethod": "claudeai"
}
```

すべてのファーストパーティログインパスが制限を適用します。[VS Code 拡張機能](/docs/ja/vs-code)、Agent SDK、`claude setup-token`、および `/install-github-app` を含みます。ただし、ターミナルのインタラクティブログイン画面（`/login` または初回実行オンボーディングで到達）は、メソッドを事前選択しますが強制しません。v2.1.212 より前は、ターミナルログインのみが適用されていました。[ログインを組織に制限する](/docs/ja/authentication#restrict-login-to-your-organization)を参照して、各ログインパス、環境認証情報、およびサードパーティプロバイダーがどのように処理されるかを確認してください。

マシン上の管理ソースが `"gateway"` を設定する場合、Claude Code は残されたログイン、API キー、または `apiKeyHelper` 認証情報を使用しません。各メッセージについては [管理者ポリシーがクラウドゲートウェイサインインを必要とします](/docs/ja/errors#administrator-policy-requires-a-cloud-gateway-sign-in)を参照してください。`CLAUDE_CODE_USE_BEDROCK` または同様の環境変数を通じてクラウドプロバイダーを選択する場合、セッションはゲートウェイサインインを必要としません。v2.1.261 より前は、Claude Code はこれらのマシンで残されたログインを使用していました。

<h3 id="forcelogingatewayurl">
  `forceLoginGatewayUrl`
</h3>

`/login` クラウドゲートウェイ画面が接続するゲートウェイ URL を設定して、ユーザーがアドレスを入力せずに [クラウドゲートウェイ](/docs/ja/claude-apps-gateway)に到達できるようにします。画面には URL フィールドがありません。このキーが設定されている場合、ゲートウェイ URL を表示し、ユーザーが Enter キーを押すと接続します。設定されていない場合、IT 管理者に連絡するよう指示します。

このキーまたは `forceLoginMethod: "gateway"` のいずれかにより、`CLAUDE_CODE_USE_*` でクラウドプロバイダーを選択するセッションを除き、マシンはゲートウェイのみになります。その場合、`/login` はログイン方法ピッカーなしでクラウドゲートウェイ画面で開きます。残されたファーストパーティログインまたは API キーに何が起こるかについては、[管理者ポリシーがクラウドゲートウェイサインインを必要とします](/docs/ja/errors#administrator-policy-requires-a-cloud-gateway-sign-in)を参照してください。画面がエラーを表示する代わりに接続するように、両方のキーを設定します。

* **スコープ**: [`Managed`](#scopes)。マシン上のソースからのみ読み取ります。`managed-settings.json`、macOS plist または Windows HKLM レジストリ、またはポリシーヘルパー。Claude Code は HKCU およびサーバー管理設定では無視します。
* **タイプ**: 文字列、スキームを含む完全な URL
* **デフォルト**: 未設定。クラウドゲートウェイ画面は IT 管理者に連絡するよう指示するエラーを表示します

```json managed-settings.json theme={null}
{
  "forceLoginGatewayUrl": "https://claude-gateway.example.com"
}
```

値が有効な URL でない場合、サインイン画面はそれを報告し、管理設定ファイルの残りは引き続き適用されます。[ゲートウェイ URL を設定する](/docs/ja/claude-apps-gateway#set-the-gateway-url)を参照してください。

<h3 id="forceloginorguuid">
  `forceLoginOrgUUID`
</h3>

管理ソースから、claude.ai アカウントログインが 1 つの Anthropic 組織（単一の UUID として指定）または複数の組織（配列として指定）に属することを要求します。任意の設定ファイルから、Claude Code は単一の UUID を使用して claude.ai または Claude Console ログイン中にその組織を事前選択し、配列の場合は何も事前選択しません。任意の設定ファイルでキーを設定する場合、Claude Code はそのファイルが適用されるセッションで [キーレス Console サインイン](/docs/ja/authentication#sign-in-without-an-api-key)の提供も停止し、代わりに API キーを作成します。

* **スコープ**: [`Any file`](#scopes)。管理ソースのみが制限を強制します。他の設定ファイルの単一の UUID は、制限なしにログイン中に組織を事前選択します。
* **タイプ**: 文字列、1 つの UUID、または文字列の配列、複数の UUID
* **デフォルト**: 未設定。任意の組織がログインできます

この例は、1 つを事前選択せずに 2 つの組織のいずれかからのログインを受け入れます。

```json managed-settings.json theme={null}
{
  "forceLoginOrgUUID": ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"]
}
```

管理ソースが空の配列を設定するか、Claude Code が解析できない値を設定する場合、Claude Code はすべてのログインを設定ミスメッセージでブロックします。

[ログインを組織に制限する](/docs/ja/authentication#restrict-login-to-your-organization)を参照して、Claude Code が Claude Console ログイン、他のログインパス、および環境認証情報をどのように扱うかを確認してください。

<h3 id="gatewayinternalnetworks">
  `gatewayInternalNetworks`
</h3>

組織が内部ネットワークに番号を付ける公開 IPv4 ブロックを宣言して、`/login` が [クラウドゲートウェイ](/docs/ja/claude-apps-gateway)をそこで受け入れるようにします。Claude Code v2.1.268 以降が必要です。

このキーがない場合、`/login` はプライベートアドレス上のゲートウェイのみに接続し、それ以外には接続しません。このキーがある場合、`/login` はリストされたブロック内のゲートウェイも受け入れます。直接接続のみです。その接続上のマシン自身のアドレスも同じブロック内にある必要があります。

* **スコープ**: [`Managed`](#scopes)。マシン上のソースからのみ読み取ります。`managed-settings.json`、macOS plist または Windows HKLM レジストリ、またはポリシーヘルパー。Claude Code は HKCU およびサーバー管理設定では無視します。
* **タイプ**: 文字列の配列、最大 4 つの IPv4 CIDR ブロック、各 `/8` から `/32`、互いに重複しない、およびプライベートスペースと重複しない
* **デフォルト**: 未設定。`/login` はプライベートアドレス上のゲートウェイのみを受け入れます

```json managed-settings.json theme={null}
{
  "gatewayInternalNetworks": ["203.0.113.0/24"]
}
```

例のドキュメンテーション範囲を独自のブロックに置き換えます。Claude Code はドキュメンテーション範囲、VPN と NAT64 クライアントがローカルで使用する範囲、およびマルチキャストなどのネットワークが番号を付けられていない予約スペースを拒否します。

エントリが無効であるか、値が文字列のリストでない場合、`/login` は問題を名前で指定し、値を修正するまでマシン上のすべての新しいゲートウェイサインインを拒否します。既存のサインインは機能し続けます。完全なルールと開発者が見るものについては、[所有する公開アドレススペース上のゲートウェイを許可する](/docs/ja/claude-apps-gateway#allow-a-gateway-on-public-address-space-you-own)を参照してください。

<h3 id="gcpauthrefresh">
  `gcpAuthRefresh`
</h3>

Claude Code が Google Cloud Application Default Credentials の有効期限が切れているか読み込めないことを検出したときにリフレッシュするために独自のコマンドを実行して、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai) リクエストが手動で再認証することなく機能し続けるようにします。

同じコマンドと認証情報を使用する複数の Claude Code プロセス（別々のターミナルや IDE ウィンドウなど）が同時に認証情報の期限切れを検出した場合、1 つのプロセスがコマンドを実行し、残りのプロセスは独自に実行を開始する代わりにその実行を待機します。リクエストを保留したまま 60 秒間待機したプロセスは、自らコマンドを実行します。この動作をオフにするには、[`CLAUDE_CODE_DISABLE_AUTH_REFRESH_LOCK`](/docs/ja/env-vars) を `1` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列、シェルコマンドライン
* **デフォルト**: 未設定。Claude Code の認証情報エラーは `gcloud auth application-default login` を自分で実行するよう指示します

```json settings.json theme={null}
{
  "gcpAuthRefresh": "gcloud auth application-default login"
}
```

[高度な認証情報設定](/docs/ja/google-vertex-ai#advanced-credential-configuration)を参照してください。

<h3 id="otelheadershelper">
  `otelHeadersHelper`
</h3>

Claude Code が OpenTelemetry エクスポートで送信するヘッダーを生成するために独自のコマンドを実行します。トークンが回転するバックエンド用です。Claude Code はスタートアップ時と定期的にその後実行し、stdout で文字列ヘッダー値の JSON オブジェクトを期待します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列、実行可能パスまたはシェルコマンドライン
* **デフォルト**: 未設定。Claude Code はヘルパー生成ヘッダーを追加しません

```json settings.json theme={null}
{
  "otelHeadersHelper": "/bin/generate_otel_headers.sh"
}
```

[`CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS`](/docs/ja/env-vars) でリフレッシュ間隔を設定します。スクリプトの要件とヘルパーが失敗した場合の動作については、[動的ヘッダー](/docs/ja/monitoring-usage#dynamic-headers)を参照してください。

<h2 id="updates-and-versioning">
  アップデートとバージョン管理
</h2>

アップデートチャネルを選択し、組織の場合はユーザーが実行できるバージョンをピン留めします。[Claude Code を更新](/docs/ja/setup#update-claude-code)を参照してください。

<h3 id="autoupdateschannel">
  `autoUpdatesChannel`
</h3>

[リリースチャネル](/docs/ja/setup#configure-release-channel)をバックグラウンド自動更新と `claude update` が従うかを選択します。通常約 1 週間前のバージョンで、大きな回帰を含むリリースをスキップする `"stable"` を設定するか、最新リリースの `"latest"` を設定します。

* **スコープ**: [`Any file`](#scopes)。組織全体で 1 つのチャネルを強制するために、管理設定で設定します。
* **タイプ**: 文字列、以下のいずれか：
  * `"latest"`：更新は最新リリースに従う
  * `"stable"`：更新は通常約 1 週間前のバージョンに従い、大きな回帰を含むリリースをスキップする
* **デフォルト**: 未設定の場合、Claude Code は `"latest"` に従う

```json settings.json theme={null}
{
  "autoUpdatesChannel": "stable"
}
```

Claude Code は `/config` の **Auto-update channel** で選択すると、ユーザー設定に `"stable"` を書き込み、そこで最新に戻すとキーを削除します。`claude install stable` と `claude install latest` も、指定したチャネルを保存します。`/config` で `"latest"` から `"stable"` に切り替えると、ダウングレードを許可するか現在のバージョンにとどまるかを尋ねます。とどまることを選択すると、[`minimumVersion`](#minimumversion) が設定されます。Homebrew インストールはこのキーを無視します：`claude-code` cask は stable を追跡し、`claude-code@latest` は latest を追跡し、`claude update` は `brew upgrade` に従います。自動更新を完全に無効にするには、`env` で [`DISABLE_AUTOUPDATER`](/docs/ja/setup#disable-auto-updates) を設定します。

<h3 id="minimumversion">
  `minimumVersion`
</h3>

バックグラウンド自動更新と `claude update` がこれより下のバージョンをインストールするのを防ぎます。これにより、`"stable"` チャネルに移動しても、より新しい `"latest"` ビルドからダウングレードされません。Claude Code は `/config` でチャネルを切り替えながら現在のバージョンにとどまることを選択すると、このキーを書き込み、`"latest"` に戻すと削除します。

* **スコープ**: [`Any file`](#scopes)。ユーザーおよびプロジェクト設定が低下させることができない、組織全体の最小値をピン留めするために、管理設定で設定します。
* **タイプ**: 文字列、`"2.1.100"` などのバージョン番号。有効なバージョンではない値は無視されます
* **デフォルト**: 未設定の場合、更新はチャネルが提供するすべてのバージョンをインストールできる

この例は stable チャネルに従い、2.1.100 より下のバージョンをインストールするのを拒否します：

```json settings.json theme={null}
{
  "autoUpdatesChannel": "stable",
  "minimumVersion": "2.1.100"
}
```

このキーは更新のみを制約します。Claude Code がバージョン以下で起動するのを拒否させるには、代わりに [`requiredMinimumVersion`](#requiredminimumversion) を使用します。[最小バージョンをピン留めする](/docs/ja/setup#pin-a-minimum-version)を参照してください。

<h3 id="requiredmaximumversion">
  `requiredMaximumVersion`
</h3>

組織が起動を許可する最新の Claude Code バージョンを設定します。実行中のバージョンがより新しい場合、Claude Code は起動時に終了し、ユーザーに組織の承認された方法を通じて承認されたバージョンをインストールするよう指示します。`claude install <version>` も機能する場合があります。Claude Code v2.1.163 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。Claude Code は他の場所でキーを無視するときに警告を表示しません。
* **タイプ**: 文字列、`"2.1.150"` などのバージョン番号。有効なバージョンではない値は無視されます
* **デフォルト**: 未設定の場合、上限は適用されません

```json managed-settings.json theme={null}
{
  "requiredMaximumVersion": "2.1.150"
}
```

バックグラウンド自動更新と `claude update` は上限より上のバージョンをスキップするため、範囲内のインストールは範囲内にとどまります。`claude update`、`claude install`、および `claude doctor` は、ユーザーが復旧できるように上限より上で機能し続けます。[`requiredMinimumVersion`](#requiredminimumversion) とペアにして、範囲を強制します。

<h3 id="requiredminimumversion">
  `requiredMinimumVersion`
</h3>

組織が起動を許可する最も古い Claude Code バージョンを設定します。実行中のバージョンがより古い場合、Claude Code は起動時に終了し、ユーザーに組織の承認された方法を通じて更新するよう指示します。チェックは起動時のみ実行されるため、既に実行中のセッションは続行されます。Claude Code v2.1.163 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。Claude Code は他の場所でキーを無視するときに警告を表示しません。
* **タイプ**: 文字列、`"2.1.150"` などのバージョン番号。有効なバージョンではない値は無視されます
* **デフォルト**: 未設定の場合、下限は適用されません

```json managed-settings.json theme={null}
{
  "requiredMinimumVersion": "2.1.150"
}
```

`claude update`、`claude install`、および `claude doctor` は、ユーザーが復旧できるように下限より下で機能し続けます。ダウングレードのみを防ぐ [`minimumVersion`](#minimumversion) とは異なり、このキーは起動をブロックします。[`requiredMaximumVersion`](#requiredmaximumversion) とペアにして、範囲を強制します。

<h2 id="tools">
  ツール
</h2>

[Claude Code デスクトップアプリ](/docs/ja/desktop)で特定のツールをオフにします。ターミナル CLI はこれらのキーを無視します。ツール自体については、[Claude が利用可能なツール](/docs/ja/tools-reference)を参照してください。

<h3 id="browserexternalpagetools">
  `browserExternalPageTools`
</h3>

デスクトップアプリの[ブラウザペイン](/docs/ja/desktop#browse-external-sites)で、Claude がそのツールを使用して外部ページを読み取ったり、外部ページに対して操作したりするのを停止します。組織内のユーザーは引き続き外部サイトを自分で開くことができ、ローカル開発サーバープレビューは Claude のツールで引き続き機能します。デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。

* **スコープ**: [`Managed`](#scopes)
* **タイプ**: 文字列、`"disabled"`。デスクトップアプリは`"disable"`も受け入れます。どちらの場合でも同じです
* **デフォルト**: 未設定。Claude のツールは外部ページで機能します

```json managed-settings.json theme={null}
{
  "browserExternalPageTools": "disabled"
}
```

その他の値を指定すると Claude のツールはオンのままになり、受け入れられた 2 つの値のいずれでもない空でない文字列は警告をログに記録します。ユーザーと Claude の両方に対して外部サイトをブロックするには、代わりに[`disableBrowserExternalNavigation`](#disablebrowserexternalnavigation)を設定してください。[組織の外部ブラウジングを制限する](/docs/ja/desktop#restrict-external-browsing-for-your-organization)を参照してください。

<h3 id="disablebrowserexternalnavigation">
  `disableBrowserExternalNavigation`
</h3>

デスクトップアプリの[ブラウザペイン](/docs/ja/desktop#browse-external-sites)で、ユーザーと Claude の両方に対して外部ブラウジングをオフにします。Localhost 開発サーバープレビューは引き続き機能します。デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。

* **スコープ**: [`Managed`](#scopes)
* **タイプ**: ブール値。JSON ブール値`true`のみが有効です
  * `true`: デスクトップアプリは、ブラウザペインでユーザーと Claude の両方に対して外部ブラウジングをオフにします。localhost プレビューは引き続き機能します
  * `false`: 外部ブラウジングはオンのままです
* **デフォルト**: 未設定。外部ブラウジングはオンです

```json managed-settings.json theme={null}
{
  "disableBrowserExternalNavigation": true
}
```

デスクトップアプリはその他の値を無視し、文字列`"true"`や`1`などのブール値ではない値も警告をログに記録します。外部ブラウジングはオンのままにしておきたいが、Claude のツールを外部ページでオフにしたい場合は、代わりに[`browserExternalPageTools`](#browserexternalpagetools)を設定してください。[組織の外部ブラウジングを制限する](/docs/ja/desktop#restrict-external-browsing-for-your-organization)を参照してください。

<h3 id="disablemobilesimulatortools">
  `disableMobileSimulatorTools`
</h3>

デスクトップアプリの[iOS シミュレータペイン](/docs/ja/desktop-ios-simulator#turn-off-simulator-access)に対する Claude のツールをブロックします。ユーザーはペインの手動使用を継続できます。Claude のアクセスのみが削除され、アプリ内から誰もそれを再度オンにすることはできません。デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。

* **スコープ**: [`Managed`](#scopes)
* **タイプ**: ブール値。JSON ブール値`true`のみが有効です
  * `true`: デスクトップアプリは iOS シミュレータペインに対する Claude のツールをブロックします
  * `false`: Claude のシミュレータツールは、デスクトップアプリ内の各ユーザーの設定トグルに従います
* **デフォルト**: 未設定。Claude のシミュレータツールは、デスクトップアプリ内の各ユーザーの設定トグルに従います

```json managed-settings.json theme={null}
{
  "disableMobileSimulatorTools": true
}
```

デスクトップアプリはその他の値を無視し、文字列`"true"`や`1`などのブール値ではない値も警告をログに記録します。

<span id="data-and-privacy" />

<h2 id="privacy-and-telemetry">
  プライバシーとテレメトリ
</h2>

Claude Code がセッションデータをどのくらいの期間保持し、何を送信するかを制御します。使用メトリクスとエラーレポートをオフにするスイッチは、設定キーではなく環境変数です。[`env`](#env) キーまたはシェルで `DISABLE_TELEMETRY`、`DISABLE_ERROR_REPORTING`、または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を設定します。[テレメトリサービス](/docs/ja/data-usage#telemetry-services) では、各環境変数が何を停止するかについて説明しています。2 つの例外は設定ファイルからオフになります。以下の [`feedbackDrafts`](#feedbackdrafts) は Claude が作成したフィードバック用、および以下の [`feedbackSurveyRate`](#feedbacksurveyrate) はセッションサーベイ用です。

<h3 id="cleanupperioddays">
  `cleanupPeriodDays`
</h3>

Claude Code が [セッショントランスクリプトおよび他のアプリケーションデータ](/docs/ja/claude-directory#cleaned-up-automatically) を削除する前に保持する日数を設定します。Claude Code はセッション開始後にバックグラウンド削除を実行します。保持期間を安全に判定できる限り実行されます。削除スイープはメッセージを表示せずにトランスクリプトを削除するため、保持期間より長く使用していないセッションは [`/resume`](/docs/ja/sessions#resume-a-session) ピッカーに表示されなくなります。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 日数、整数、最小値 `1`
* **デフォルト**: `30`

```json settings.json theme={null}
{
  "cleanupPeriodDays": 20
}
```

`0` を設定するとバリデーションが失敗するため、長期保持の場合は `3650` などの大きな値を選択してください。Claude Code がトランスクリプトを書き込まないようにするには、[プレーンテキストストレージ](/docs/ja/claude-directory#plaintext-storage) を参照してください。

<h3 id="desktopsessioncleanupperioddays">
  `desktopSessionCleanupPeriodDays`
</h3>

Claude Desktop または Cowork で開始または最後に続行したセッションのトランスクリプトに対して、日数での年齢制限を設定します。このキーがない場合、Claude Code は [それらのトランスクリプトを任意の年齢で保持します](/docs/ja/claude-directory#cleaned-up-automatically)。Claude Code は各トランスクリプトが、この制限と [`cleanupPeriodDays`](#cleanupperioddays) の両方より古い場合に削除します。したがって、`cleanupPeriodDays` がデフォルトの 30 の場合、`7` の値でも 30 日間保持されます。[自動クリーンアップ](/docs/ja/claude-directory#cleaned-up-automatically) には、代わりに `cleanupPeriodDays` が適用され、Claude Code がこのキーを無視するケースが記載されています。Claude Code v2.1.248 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。Claude Code は `--settings` で渡すファイルからキーを読み込み、プロジェクトおよびローカル設定では無視します。
* **タイプ**: 日数、整数、最小値 `0`
* **デフォルト**: `0`。年齢制限を設定しません

```json settings.json theme={null}
{
  "desktopSessionCleanupPeriodDays": 90
}
```

<h3 id="feedbackdrafts">
  `feedbackDrafts`
</h3>

[Claude が作成したフィードバック](/docs/ja/tools-reference#sendfeedback-tool-behavior) を制御します。Claude がレビュー用のフィードバックドラフトをキューに入れることができるかどうか、および Claude Code が Claude がドラフトをキューに入れたときにカードを表示するかどうかを制御します。

* **スコープ**: [`User or managed`](#scopes)
* **タイプ**: 文字列。`"notify"`、`"quiet"`、または `"off"` のいずれか
  * `"notify"`：Claude Code は Claude がドラフトをキューに入れたときにプロンプトの上にカードを表示します。デフォルトではセッションあたり [最大 3 枚のカード](/docs/ja/tools-reference#what-you-see-when-claude-drafts)
  * `"quiet"`：Claude はカードなしでドラフトを作成します。プロンプトフッターでキューに入れられたドラフトの数を確認し、`/feedback` でレビューします
  * `"off"`：Claude Code は SendFeedback ツールを削除するため、Claude はドラフトをキューに入れることができません
* **デフォルト**: `"notify"`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_SEND_FEEDBACK`](/docs/ja/env-vars) を `0` に設定すると、1 つのセッションでこの機能がオフになります

```json settings.json theme={null}
{
  "feedbackDrafts": "quiet"
}
```

`/config` に **Claude-drafted feedback** として表示されます。これはこのキーをユーザー設定に書き込みます。`/config` 行は [Claude がフィードバックドラフトを作成できるセッション](/docs/ja/tools-reference#sessions-without-claude-drafted-feedback) でのみ表示されます。`"off"` を設定してもこれは非表示にならないため、同じ行から機能を再度オンにできます。管理設定の値はユーザー設定より優先されるため、管理者がこのキーを設定すると、行は管理値を表示し、変更しても効果がありません。Claude Code はプロジェクトおよびローカル設定でこのキーを無視します。

<h3 id="feedbacksurveyrate">
  `feedbackSurveyRate`
</h3>

[セッション品質サーベイ](/docs/ja/data-usage#session-quality-surveys) がセッションがそれに適格である場合に表示される確率を設定します。`0` を設定してサーベイが表示されないようにします。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: `0` から `1` の間の数値
* **デフォルト**: 未設定。Claude Code は Anthropic がリモートで設定する率を使用するか、Amazon Bedrock、Google Cloud の Agent Platform、および Microsoft Foundry でのビルトイン率 `0.005` を使用します。これらはリモート設定を受け取りません
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY`](/docs/ja/env-vars) を `1` に設定すると、このキーが設定する率に関係なく、1 つのセッションでサーベイがオフになります

```json settings.json theme={null}
{
  "feedbackSurveyRate": 0.05
}
```

同じ率が VS Code 拡張機能のサーベイに適用されます。

<h3 id="skipwebfetchpreflight">
  `skipWebFetchPreflight`
</h3>

[WebFetch ドメイン安全性チェック](/docs/ja/data-usage#webfetch-domain-safety-check) をスキップします。このチェックは、フェッチする前に各リクエストされたホスト名を `api.anthropic.com` に送信します。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry デプロイメント（制限的な出力を持つ）など、Anthropic へのトラフィックをブロックする環境で `true` を設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: ブール値
  * `true`：Claude Code は WebFetch ドメイン安全性チェックをスキップします
  * `false`：チェックはセッション内の各ホスト名への最初のフェッチの前に実行され、以前のチェックがブロックされたか失敗したホスト名に対して再度実行されます
* **デフォルト**: 未設定。チェックはセッション内の各ホスト名への最初のフェッチの前に実行されます

```json settings.json theme={null}
{
  "skipWebFetchPreflight": true
}
```

チェックがスキップされた場合、WebFetch はブロックリストを参照せずに任意の URL を試行するため、Claude が到達できるドメインを制限する必要がある場合は [`WebFetch` 権限ルール](/docs/ja/permissions#webfetch) と組み合わせてください。

<span id="managed-policy" />

<h2 id="enterprise-and-managed-settings">
  エンタープライズおよび管理設定
</h2>

組織が管理設定を計算、更新、および組み合わせるために使用するキー。[管理設定の設定](/docs/ja/admin-setup)を参照してください。

<h3 id="disablesideloadflags">
  `disableSideloadFlags`
</h3>

起動時に `--plugin-dir`、`--plugin-url`、`--agents`、および `--mcp-config` CLI フラグを拒否します。これらのフラグは、ユーザーが [`strictKnownMarketplaces`](#strictknownmarketplaces) を単一実行でバイパスするために渡す可能性があります。Claude Code はエラーで終了し、拒否されたフラグを名前で指定します。[クラウドセッション](/docs/ja/claude-code-on-the-web)では、Claude Code はセッションを開始し、サーバーが配信した `--mcp-config` エントリをドロップします。ただし、プロセス内 `type: "sdk"` エントリと [Claude Tag](/docs/ja/claude-tag) セッションの Slack ツールは除きます。Claude Code v2.1.193 以降が必要です。

* **スコープ**: [`Managed`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は起動時に `--plugin-dir`、`--plugin-url`、`--agents`、および `--mcp-config` を拒否し、エラーで終了して名前を指定します。クラウドセッションでは、セッションを開始し、サーバーが配信した `--mcp-config` エントリをドロップします。ただし、プロセス内 `type: "sdk"` エントリと Claude Tag セッションの Slack ツールは除きます
  * `false`: Claude Code はこれらのフラグを受け入れます
* **デフォルト**: `false`

```json managed-settings.json theme={null}
{
  "disableSideloadFlags": true
}
```

Claude Code は、サーバーがすべてプロセス内 `type: "sdk"` エントリである `--mcp-config` を受け入れます。これにより、Agent SDK と VS Code 拡張機能は動作し続けます。ユーザーは `claude mcp add` またはファイル `.mcp.json` でサーバーを追加できます。サーバーごとの制御については、[`allowedMcpServers`](/docs/ja/managed-mcp) も設定してください。Claude Code v2.1.193 以降が必要です。

同じチェックは、[`CLAUDE_CODE_PLUGIN_DIRS`](/docs/ja/env-vars#variables) 環境変数で名前が付けられたプラグインフォルダをカバーします。これには Claude Code v2.1.280 以降が必要です。変数がフォルダを名前で指定する場合、Claude Code は同じエラーで終了し、エラーは変数をアンセットするように指示します。

クラウドセッションでは、Claude Code はセッション中の MCP 更新も無視します。これは、クラウドセッション構成と SDK `setMcpServers()` 呼び出しの背後にあるパスです。プロセス内 `type: "sdk"` エントリと Claude Tag セッションの Slack ツールはそこでも除外されたままです。v2.1.268 より前では、このドロップと起動ドロップの両方も Claude Tag セッションの Slack ツールを削除していました。v2.1.239 より前では、サーバーが配信した `--mcp-config` はクラウドセッションの開始をブロックしていました。

デスクトップアプリは、claude.ai から同期されたプラグインや、組織がアプリを通じてデプロイするプラグインを含む、いくつかのプラグインを自身で管理します。MDM、OS レベルのポリシー、または管理設定ファイルを通じてこのキーをデバイスにデプロイする場合、デスクトップアプリはそれらのプラグインを、そのデバイス上の以下のセッションに渡しません:

* **[ユーザーのマシン上のコードセッション](/docs/ja/desktop#environment-configuration)**: ユーザーの claude.ai アカウントに対して有効になっているスキルなしでも開始します。Claude Code が管理設定のマーケットプレイスからインストールするプラグインは引き続きロードされます。[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview) では、デバイスの `org-plugins` ディレクトリにデプロイするプラグインからの MCP サーバーは利用可能なままです。デスクトップアプリが自身でそれらに接続するため。Claude Desktop v1.37937.0 より前では、これらのセッションは起動時に失敗していました。
* **[ユーザーのマシン上の Cowork セッション](/docs/ja/managed-settings#where-and-when-a-policy-applies)**: それらのプラグイン内のスキルとユーザーの claude.ai アカウントに対して有効になっているスキルは利用可能なままです。[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview) では、デバイスの `org-plugins` ディレクトリにデプロイするプラグインからの MCP サーバーは利用可能なままです。デスクトップアプリが自身でそれらに接続するため。Claude Desktop v1.44121.0 より前では、これらのセッションは起動時に失敗していました。

<h3 id="forceremotesettingsrefresh">
  `forceRemoteSettingsRefresh`
</h3>

Claude Code が [サーバー管理設定](/docs/ja/server-managed-settings) を新たに取得するまで CLI 起動をブロックします。取得に失敗した場合、Claude Code はキャッシュされた設定または設定なしで続行する代わりに終了します。環境が管理ポリシーなしでセッションが実行される短い時間枠を受け入れられない場合に設定します。

キーが設定されていない場合、Claude Code は取得時に起動をブロックしません。ただし、開発者が起動時にサインインする場合、取得を最大 5 秒間待機します。Cloud ゲートウェイセッションは常に待機し、ゲートウェイに到達できない場合は終了します。

* **スコープ**: [`Managed`](#scopes)。Claude Code は、最優先度のソースでなくても、管理者が制御する管理ソースからの `true` を尊重します。
* **タイプ**: ブール値
  * `true`: Claude Code は起動をブロックして、サーバー管理設定を新たに取得するまで待機し、取得に失敗した場合は終了します
  * `false`: Claude Code は取得時に起動をブロックしません。ただし、サインイン起動では最大 5 秒間待機します
* **デフォルト**: `false`

```json managed-settings.json theme={null}
{
  "forceRemoteSettingsRefresh": true
}
```

MDM プロファイルまたは管理設定ファイルで設定して、最初のサーバーペイロードが到着する前に失敗時閉鎖起動を強制します。Claude Code は、サーバー管理設定を取得するセッションでのみチェックを適用します。[それらを取得しないセッション](/docs/ja/server-managed-settings#platform-availability)は待機なしで開始します。`claude auth` サブコマンドは除外されるため、ユーザーは期限切れの認証情報が取得に失敗する理由である場合に再認証できます。[失敗時閉鎖起動を強制する](/docs/ja/server-managed-settings#enforce-fail-closed-startup)を参照してください。

<h3 id="managedsourcesbehavior">
  `managedSourcesBehavior`
</h3>

Claude Code が、組織が配信する最優先度の [管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) のみを適用するか、配信するすべての管理者ソースを組み合わせるかを選択します。デフォルトでは、Claude Code は [ポリシーキー](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) を含む最優先度のソースを取得し、残りを無視します。ポリシーキーは、このキーと `wslInheritsWindowsSettings` 以外の設定キーです。そのデフォルトでは、サーバー管理設定または MDM ポリシーがポリシーキーを配信すると、`managed-settings.json` ファイルは [Claude Code がすべての管理ソースから読み取るキー](/docs/ja/managed-settings#keys-read-from-every-admin-source) のみを提供します。`"merge"` を使用すると、配信するすべての管理ソースがそのキーを 1 つの組み合わせたポリシーに提供します。Claude Code v2.1.242 以降が必要です。

`"merge"` は、[ランク付けされた](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) 最優先度のソースの下のすべてのソースが管理者の制御下にある場合にのみ設定してください。Claude Code は、`permissions.allow` ルールなどの下位ソースからのエントリをポリシーに追加します。

* **スコープ**: [`Managed`](#scopes)。Claude Code はこのキーを、このキーまたはポリシーキーを含む最優先度のソースから読み取り、ランク付けされた下位のすべてのソースでこのキーを無視します。下位ソースは、上位のソースとの組み合わせにオプトインできません。Windows HKCU レジストリも [埋め込みホストからの親設定](/docs/ja/managed-settings#let-an-embedding-host-add-policy) も、マージに参加しません。
* **タイプ**: 文字列、次のいずれか:
  * `"first-wins"`: ポリシーキーを含む最優先度のソースがポリシーを提供し、下位ソースは [Claude Code がすべての管理ソースから読み取るキー](/docs/ja/managed-settings#keys-read-from-every-admin-source) のみを提供します
  * `"merge"`: 配信するすべての管理ソースがそのキーを提供し、以下のルールで組み合わせられます
* **デフォルト**: `"first-wins"`

デプロイする最優先度のソースでキーを配信します。サーバー管理設定を受け取らないマシンは、Claude Code がこのキーまたはポリシーキーを含む最優先度のソースからキーを読み取るため、MDM プロファイルにもキーが必要です。`managed-settings.json` ファイルは最下位の管理ソースであるため、そこに設定された `"merge"` は、それと組み合わせる下位ソースがありません。サーバー管理設定では、キーは次のようになります:

```json theme={null}
{
  "managedSourcesBehavior": "merge"
}
```

`"merge"` では、Claude Code は各キーをそのタイプで組み合わせます。このテーブルは各タイプのルールを示します。制限許可リスト、値全体取得、および最優先度ソースのみの行は、カバーするすべてのキーを名前で指定し、他の行は例を示します:

| キーのタイプ | Claude Code がそれを組み合わせる方法 | キー |
| :- | :- | :- |
| リスト | すべてのソースからのエントリを組み合わせます | [`permissions.allow`](#permissions-allow)、[`sandbox.network.allowedDomains`](#sandbox-network-alloweddomains)、およびその他のリストキー |
| ロック | ソースが設定する最も厳密な値を適用します。ソースが厳密な値を設定しない場合、最優先度のソースからのみより緩い値を適用します | [`allowManagedPermissionRulesOnly`](#allowmanagedpermissionrulesonly)、[`permissions.disableBypassPermissionsMode`](#permissions-disablebypasspermissionsmode)、およびその他のブール値または列挙型ロック |
| 制限許可リスト | 下位ソースからのエントリを追加せずに、それを設定する最優先度のソースから全体を取得します。最優先度のソースが設定しない場合、次のソースから全体を取得します | [`availableModels`](#availablemodels)、[`allowedMcpServers`](#allowedmcpservers)、[`allowedProviders`](#allowedproviders)、[`strictKnownMarketplaces`](#strictknownmarketplaces)、[`allowedChannelPlugins`](#allowedchannelplugins)、および [`fallbackModel`](#fallbackmodel) チェーン |
| 値全体取得 | 下位ソースからのエントリまたはフィールドを組み合わせずに、それを設定する最優先度のソースから全体を取得します。最優先度のソースが設定しない場合、次のソースから全体を取得します | [`sandbox.credentials.awsPairs`](#sandbox-credentials-awspairs)、[`sandbox.ripgrep`](#sandbox-ripgrep) |
| 提供される MCP サーバー | すべてのソースからサーバー名を組み合わせます。2 つのソースが同じ名前を設定する場合、上位ソースの全体エントリを適用します | [`managedMcpServers`](#managedmcpservers) |
| 最優先度のソースからのみ読み取ります | ポリシーキーを含む最優先度のソースからのみキーを読み取るため、最優先度のソースが何も設定しない場合でも、下位ソースの値は無視されます | [`apiKeyHelper`](#apikeyhelper)、[`awsAuthRefresh`](#awsauthrefresh)、[`awsCredentialExport`](#awscredentialexport)、[`gcpAuthRefresh`](#gcpauthrefresh)、[`otelHeadersHelper`](#otelheadershelper)、`proxyAuthHelper`、[`forceLoginOrgUUID`](#forceloginorguuid)、[`forceLoginMethod`](#forceloginmethod) の `"claudeai"` および `"console"` 値、[`parentSettingsBehavior`](#parentsettingsbehavior)、[`modelPicker`](#modelpicker)、[`policyHelper`](#policyhelper)、[`permissions.defaultMode`](#permissions-defaultmode) |
| `env` | [管理ソース全体で変数ごとにマージします](/docs/ja/managed-settings#keys-read-from-every-admin-source)。`"first-wins"` と `"merge"` の両方で | [`env`](#env) |
| その他のすべてのキー | それを設定する最優先度のソースから値を取得します | [`cleanupPeriodDays`](#cleanupperioddays)、[`model`](#model) |

`sandbox.credentials.awsPairs` と `sandbox.ripgrep` を全体で取得するには、Claude Code v2.1.257 以降が必要です。

いくつかのキーは、テーブルが示さない条件を追加します:

* **[`policyHelper`](#policyhelper)**: Claude Code は、ポリシーキーを含む最優先度のソースが MDM ポリシーまたは管理設定ファイルである場合にのみそれを尊重します。サーバー管理設定では適用されません。
* **[`modelOverrides`](#modeloverrides)**: `availableModels` とペアになります。Claude Code は、それを設定する最優先度のソースから `modelOverrides` を取得します。ただし、上位ソースが `modelOverrides` なしで `availableModels` を設定する場合は除きます。その場合、すべてのソースから `modelOverrides` を無視します。
* **[`forceLoginGatewayUrl`](#forcelogingatewayurl)、[`gatewayInternalNetworks`](#gatewayinternalnetworks)、および [`forceLoginMethod`](#forceloginmethod) の `"gateway"` 値**: Claude Code はサーバー管理設定からそれらのいずれも読み取りません。そのため、そこでの値は適用されず、MDM ポリシーまたは管理設定ファイルで設定されたものを隠しません。マシン上の管理ソースの中で、ポリシーキーを含む最優先度のソースのみがそれらを提供します。サーバー管理設定も存在するかどうかに関わらず。
* **[`allowedProviders`](#allowedproviders)**: テーブルのルールの後、マシン自体のリストは結果を制限し続けます。そのエントリの Scope ノートが述べているように。

マシンで組み合わせたソースを確認するには、`/status` を実行し、[`Setting sources` 行を読んでください](/docs/ja/managed-settings#read-the-source-in-/status)。

<h3 id="parentsettingsbehavior">
  `parentSettingsBehavior`
</h3>

Claude Code が、Agent SDK または IDE 拡張機能などの埋め込みホストプロセスによって提供される管理設定を適用するかどうかを選択します。管理者がデプロイした管理層も存在する場合。`"first-wins"` では、Claude Code はホスト提供の設定をドロップします。`"merge"` では、制限のみのフィルターを通じて管理層の下で適用します。ホストが起動するセッションに独自の制限を渡す必要がある場合、`"merge"` を設定します。たとえば、Claude Desktop がゲートウェイの出力許可リストを配信する場合。

* **スコープ**: [`Managed`](#scopes)。Claude Code はそれを最優先度の管理者制御管理ソースから読み取ります。
* **タイプ**: 文字列、次のいずれか:
  * `"first-wins"`: Claude Code は、管理者がデプロイした管理層が存在する場合、ホスト提供の設定をドロップします
  * `"merge"`: Claude Code は、制限のみのフィルターを通じて管理層の下でホスト提供の設定を適用します
* **デフォルト**: `"first-wins"`

```json managed-settings.json theme={null}
{
  "parentSettingsBehavior": "merge"
}
```

管理者がデプロイした管理層が存在しない場合、このキーは効果がありません。ホストの設定は、唯一の管理層として適用されます。制限値にフィルターされたままです。フィルターの制限と管理ソースの相互作用については、[埋め込みホストからの親設定](/docs/ja/managed-settings#parent-settings-from-embedding-hosts) および [親設定を制限する](/docs/ja/claude-apps-gateway#restrict-parent-settings) を参照してください。

<span id="compute-managed-settings-with-a-policy-helper" />

<h3 id="policyhelper">
  `policyHelper`
</h3>

起動時に管理設定を計算するためにデプロイする実行可能ファイルを実行します。デバイスの状態、ID、またはリモートサービスから静的ファイルの代わりにポリシーを導出できます。Claude Code はヘルパーを実行してから最初のプロンプトを受け入れ、それが出力する設定をセッションの管理設定として扱います。

* **スコープ**: [`Managed`](#scopes)。macOS plist、Windows HKLM レジストリ、または管理設定ファイルから読み取ります。Claude Code は、[ポリシーキー](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) を含む最優先度の管理ソースからキーを読み取り、そのソースが 3 つのうちの 1 つである場合にのみヘルパーを実行します。サーバー管理設定、HKCU レジストリ、およびホスト提供の親設定ではキーを無視します。
* **タイプ**: `path`、`timeoutMs`、および `refreshIntervalMs` を含むオブジェクト
* **デフォルト**: 設定されていないため、ヘルパーは実行されません

サーバー管理設定が起動時にポリシーを配信する場合、ヘルパーのソースより優先され、ヘルパーは実行されません。

後の設定取得がサーバー管理設定が削除されたことを報告する場合、Claude Code はその時点でヘルパーを実行します。次の起動を待つ代わりに。その出力はセッションの残りを管理し、失敗した実行は [失敗した起動実行](#helper-failures) と同じメッセージでセッションを終了します。

この例は、5 秒のタイムアウトでヘルパーを実行し、5 分ごとに再実行します:

```json managed-settings.json theme={null}
{
  "policyHelper": {
    "path": "/usr/local/bin/claude-policy",
    "timeoutMs": 5000,
    "refreshIntervalMs": 300000
  }
}
```

<h4 id="write-the-helper-output">
  ヘルパー出力を書き込む
</h4>

Claude Code はヘルパーを引数なしで実行し、その環境に `CLAUDE_CODE_VERSION` を設定し、stdout から JSON エンベロープを読み取ります。1 MiB でキャップされます。

設定を `managedSettings` キーの下に配置します。`managedSettings` キーのない裸の設定オブジェクトは、`managedSettings` が未定義で何も適用されず、Claude Code はエラーを報告しません:

```json theme={null}
{
  "managedSettings": {
    "permissions": { "deny": ["Read(//etc/secrets/**)"] }
  }
}
```

ヘルパーが `managedSettings` を出力する場合、そのオブジェクトは実行の唯一の管理設定ソースになります。Claude Code は MDM、ファイル、および HKCU ソースを無視し、[クロスソースキー](/docs/ja/managed-settings#keys-read-from-every-admin-source) をヘルパーの出力からのみ読み取り、[親設定](/docs/ja/managed-settings#parent-settings-from-embedding-hosts) をマージしません。

起動 `forceRemoteSettingsRefresh` チェックはヘルパーの前に実行され、任意の管理ソースを読み取ります。ヘルパーが `managedSettings` を省略するエンベロープで `0` で終了する場合、管理設定を提供しません。他のソースは通常どおり適用されます。

<h4 id="helper-failures">
  ヘルパーの失敗
</h4>

ヘルパー実行は次の場合に失敗します:

* `path` は [`policyHelper.path`](#policyhelper-path) のルールを破ります。
* `path` に通常ファイルがありません。Claude Code は、同じ `timeoutMs` 予算内でヘルパーを開始する前にファイルをチェックするため、応答しないネットワークマウントは実行を失敗させる可能性があります。
* ヘルパーが 0 以外で終了し、`timeoutMs` が経過してもまだ実行中であるか、まったく開始しません。たとえば、実行可能でないため。
* ヘルパーが stdout または stderr に 1 MiB 以上を書き込みます。
* stdout は単一の JSON オブジェクトではないか、その `managedSettings` に [Claude Code が修復できないスキーマ違反](/docs/ja/managed-settings#find-entries-claude-code-dropped) があります。

起動実行が失敗する場合、Claude Code は理由を出力し、起動を拒否します。0 以外の終了後、理由にはヘルパーの stderr が含まれます。stderr が空の場合は stdout が含まれます。タイムアウト後、理由は `timeoutMs` 制限を名前で指定し、ヘルパーの出力は含まれません。拒否は、対話型セッション、`claude -p`、Agent SDK セッション、[バックグラウンドセッション](/docs/ja/agent-view)、およびほとんどのサブコマンドをカバーします。

拒否は意図的なため、停止復旧が必要なヘルパーは独自のキャッシュから提供し、`0` で終了する必要があります。

バックグラウンド更新が失敗する場合、Claude Code は最後に成功したポリシーを有効に保ち、`/status` は失敗した更新をその理由とともに表示します。更新が成功するまで。各更新は、起動実行と同じ `timeoutMs` および失敗ルールの下で実行されます。

`--debug` を使用すると、Claude Code はすべての実行からヘルパーの stderr を [デバッグログ](/docs/ja/debug-your-config) に書き込みます。

Claude Code は無効な `policyHelper` 値を [ドロップされたエントリ](/docs/ja/managed-settings#find-entries-claude-code-dropped) として報告し、残りの管理設定でセッションを開始します。ヘルパーを実行しません。無効な値には、裸のパス文字列と [その最小値](#policyhelper-timeoutms) より低い `timeoutMs` が含まれます。

ヘルパーをオフにするには、それを設定するソースからキーを削除します。

<h3 id="policyhelper-path">
  `policyHelper.path`
</h3>

Claude Code が実行するヘルパー実行可能ファイルに名前を付けます。パスがルールを破る場合に何が起こるかについては、[ヘルパーの失敗](#helper-failures) を参照してください。

* **スコープ**: [`Managed`](#scopes)。macOS plist、Windows HKLM レジストリ、または管理設定ファイルから読み取ります。[`policyHelper`](#policyhelper) が読み取られる場所。
* **タイプ**: 文字列、正規化された形式の絶対パス。`.` または `..` セグメントなし。Windows では、`.exe` で終わるドライブレターまたは UNC パス
* **デフォルト**: なし。`policyHelper` が設定されている場合は必須

```json managed-settings.json theme={null}
{
  "policyHelper": {
    "path": "/usr/local/bin/claude-policy"
  }
}
```

<h3 id="policyhelper-timeoutms">
  `policyHelper.timeoutMs`
</h3>

Claude Code がヘルパーを待機する時間を設定してから、実行を失敗として扱います。タイムアウトした実行は 0 以外の終了と同じ方法で失敗するため、起動時に Claude Code は起動を拒否します。

* **スコープ**: [`Managed`](#scopes)。macOS plist、Windows HKLM レジストリ、または管理設定ファイルから読み取ります。[`policyHelper`](#policyhelper) が読み取られる場所。
* **タイプ**: 整数、ミリ秒、最小 `1000`
* **デフォルト**: `10000`

```json managed-settings.json theme={null}
{
  "policyHelper": {
    "path": "/usr/local/bin/claude-policy",
    "timeoutMs": 5000
  }
}
```

<h3 id="policyhelper-refreshintervalms">
  `policyHelper.refreshIntervalMs`
</h3>

Claude Code がバックグラウンドでヘルパーを間隔で再実行するようにして、ポリシーの変更が実行中のセッションに到達するようにします。更新が成功する場合、その出力は前の管理設定を再起動なしで置き換えます。更新が失敗する場合、Claude Code は既に持っているポリシーを保ちます。

* **スコープ**: [`Managed`](#scopes)。macOS plist、Windows HKLM レジストリ、または管理設定ファイルから読み取ります。[`policyHelper`](#policyhelper) が読み取られる場所。
* **タイプ**: 整数、ミリ秒: 更新を無効にするには `0`。それ以外の場合は最小 `60000`
* **デフォルト**: 設定されていないため、Claude Code はヘルパーを起動時に 1 回実行します

この例は、5 分ごとにヘルパーを再実行します:

```json managed-settings.json theme={null}
{
  "policyHelper": {
    "path": "/usr/local/bin/claude-policy",
    "refreshIntervalMs": 300000
  }
}
```

<h3 id="wslinheritswindowssettings">
  `wslInheritsWindowsSettings`
</h3>

WSL 上の Claude Code が Windows ポリシーチェーンから管理設定を読み取るようにします。HKLM と Windows 管理設定ファイルが `/etc/claude-code` と下の HKCU より優先されます。チェーンがオンの間、Claude Code は [Windows 管理ドキュメントが存在しない](/docs/ja/managed-settings#present-admin-documents) 場合にのみ `/etc/claude-code` を読み取ります。HKLM レジストリ値または `C:\Program Files\ClaudeCode\` フォルダ内。Windows に既にデプロイしているポリシーを WSL セッションに拡張するために設定します。同じマシン上で、ホストセッションと同じルールに従うようにします。Claude Code は、HKLM レジストリキーまたは管理設定ファイルまたは `C:\Program Files\ClaudeCode\` の下のドロップインで設定されている場合にのみそれを尊重します。どちらも Windows 管理者が書き込む必要があります。

* **スコープ**: [`Managed`](#scopes)。管理者制御の Windows ソースで。
* **タイプ**: ブール値
  * `true`: WSL 上の Claude Code は Windows ポリシーチェーンから管理設定を読み取り、Windows 管理ドキュメントが存在しない場合にのみ `/etc/claude-code` を読み取ります
  * `false`: WSL は `/etc/claude-code` のみを読み取ります
* **デフォルト**: `false`。WSL は `/etc/claude-code` のみを読み取ります

```json managed-settings.json theme={null}
{
  "wslInheritsWindowsSettings": true
}
```

管理ソースがチェーンをオンにすると、HKCU ポリシーは HKCU もキーを `true` に設定する場合にのみ WSL に参加します。そのコピーはチェーンをそれ自体でオンにしません。このキーのみを含む Windows ソース。`true` または `false` に設定されている場合、ポリシーソースとしてカウントされません。下位優先度のソースはまだポリシーを提供します。このキーはネイティブ Windows に効果がありません。

Claude Code は `true` と `false` を引用符の有無にかかわらず読み取り、`null` をキーの削除として読み取ります。他の値を保持する管理者制御の Windows ソースは、[存在する管理ドキュメント](/docs/ja/managed-settings#present-admin-documents) としてカウントされます。チェーンがオンの場合: `/etc/claude-code` も HKCU も適用されず、起動警告がキーを名前で指定します。読み取ることができない HKLM 値または Windows フォルダファイルも、チェーンがオンかどうかに関わらず `/etc/claude-code` が適用されるのを防ぎます。Claude Code v2.1.282 以降が必要です。

<h2 id="global-config-settings">
  グローバル設定
</h2>

これらのキーを `~/.claude.json` に保存してください。設定ファイルには保存しないでください。Claude Code はそれ以外の場所ではこれらを無視します。Claude Code と `/config` はほとんどのキーを自動的に書き込みます。また、手動で編集することもできます。

<h3 id="autoconnectide">
  `autoConnectIde`
</h3>

外部ターミナルから Claude Code を起動するときに、実行中の IDE に自動的に接続します。VS Code または JetBrains ターミナルの外で Claude Code を実行する場合、`/config` に **Auto-connect to IDE (external terminal)** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は外部ターミナルから起動するときに、実行中の IDE に自動的に接続します
  * `false`: Claude Code は外部ターミナルから自動的に接続しません。ただし、VS Code または JetBrains ターミナル内、または `--ide` を使用する場合は接続します
* **デフォルト**: `false`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_AUTO_CONNECT_IDE`](/docs/ja/env-vars) はこのキーより優先され、1 つのセッションでどちらの方向でも機能します

```json ~/.claude.json theme={null}
{
  "autoConnectIde": true
}
```

Claude Code は `settings.json` でこのキーを無視します。

<h3 id="autoinstallideextension">
  `autoInstallIdeExtension`
</h3>

VS Code ターミナルから Claude Code を実行するときに、Claude Code IDE 拡張機能を自動的にインストールします。VS Code または JetBrains ターミナル内で Claude Code を実行する場合、`/config` に **Auto-install IDE extension** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は VS Code ターミナルから実行するときに IDE 拡張機能を自動的にインストールします
  * `false`: Claude Code は拡張機能を自動的にインストールしません
* **デフォルト**: `true`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL`](/docs/ja/env-vars) を `1` に設定すると、このキーが `true` の場合でも 1 つのセッションのインストールをスキップします

```json ~/.claude.json theme={null}
{
  "autoInstallIdeExtension": false
}
```

Claude Code は `settings.json` でこのキーを無視します。

<h3 id="claudeinchromedefaultenabled">
  `claudeInChromeDefaultEnabled`
</h3>

[Chrome 統合](/docs/ja/chrome)をオンにして、毎回 `--chrome` を渡さずにすべてのインタラクティブ CLI セッションを開始します。[`claude remote-control`](/docs/ja/remote-control) を実行する場合、[プロジェクト](/docs/ja/claude-projects)スレッドの 1 つに対して開始するセッションもこのキーに従います。ただし、`bypassPermissions` モードの場合は除きます。Claude Code v2.1.287 以降では、このキーは [VS Code 拡張機能](/docs/ja/vs-code#automate-browser-tasks-with-chrome)のセッションにも適用されます。詳しくは [Chrome をデフォルトで有効にする](/docs/ja/chrome#enable-chrome-by-default)を参照してください。

`/chrome` を実行して **Enabled by default** を選択すると、このキーが設定されます。`/config` に **Claude in Chrome enabled by default** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は `--chrome` を渡すときと同様に、インタラクティブ CLI セッションが開始するときに Chrome 統合をオンにします。VS Code 拡張機能では、セッションは開始時にブラウザに接続します
  * `false`: インタラクティブ CLI セッションは Chrome 統合をオフで開始し、Claude Code は[セットアップを提案するのを停止](/docs/ja/chrome#install-the-extension-when-claude-asks)します。1 つのインタラクティブセッションでオンにするには `--chrome` を渡してください。VS Code 拡張機能では、キーが未設定の場合と同様に、`@browser` と入力したときにセッションが接続します
* **デフォルト**: 未設定。Chrome 統合はオフで、Claude Code はセットアップを提案できます
* **セッションごとのオーバーライド**: `--chrome` と [`--no-chrome`](/docs/ja/cli-reference) はこのキーより優先され、1 つのインタラクティブセッションで機能します

```json ~/.claude.json theme={null}
{
  "claudeInChromeDefaultEnabled": true
}
```

Claude Code は `settings.json` でこのキーを無視します。

<h3 id="copyfullresponse">
  `copyFullResponse`
</h3>

[`/copy`](/docs/ja/commands) が応答に含まれるコードブロックがある場合に表示するピッカーなしで、毎回完全な応答をコピーします。そのピッカーで **Always copy full response** を選択すると、このキーが `true` に設定されます。`/config` に **Skip the /copy picker** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: `/copy` はピッカーを表示せずに完全な応答をコピーします
  * `false`: 応答にコードブロックが含まれている場合、`/copy` はピッカーを表示し、1 つのコードブロックまたは完全な応答を選択できます
* **デフォルト**: `false`

```json ~/.claude.json theme={null}
{
  "copyFullResponse": true
}
```

Claude Code は `settings.json` でこのキーを無視します。

<h3 id="copyonselect">
  `copyOnSelect`
</h3>

[フルスクリーンレンダリング](/docs/ja/fullscreen#use-the-mouse)または[エージェントビュー](/docs/ja/agent-view)でマウスで選択を終了したときに、テキストをクリップボードに自動的にコピーします。フルスクリーンレンダリングがオンの場合、`/config` に **Copy on select** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は選択を終了したときにテキストをクリップボードにコピーします
  * `false`: テキストを選択してもクリップボードは変わらず、代わりに[キーボードショートカットで選択をコピー](/docs/ja/fullscreen#use-the-mouse)します
* **デフォルト**: `true`

```json ~/.claude.json theme={null}
{
  "copyOnSelect": false
}
```

Claude Code は `settings.json` でこのキーを無視します。

<h3 id="defaulttoagentsview">
  `defaultToAgentsView`
</h3>

引数なしで `claude` を実行するときに、新しい会話の代わりに[エージェントビュー](/docs/ja/agent-view)を開きます。エージェントビューが[オフ](#disableagentview)になっていない限り、`/config` に **Open agents view by default** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: 引数なしの `claude` はエージェントビューを開きます。ただし、エージェントビューが[オフ](#disableagentview)になっている場合は除きます
  * `false`: 引数なしの `claude` は新しい会話を開始します
* **デフォルト**: `false`

```json ~/.claude.json theme={null}
{
  "defaultToAgentsView": true
}
```

Claude Code は `settings.json` でこのキーを無視します。

<h3 id="difftool">
  `diffTool`
</h3>

[VS Code](/docs/ja/vs-code)または[JetBrains](/docs/ja/jetbrains#features) IDE が接続されているときに、Claude Code が提案する `Edit` または `Write` 変更の差分を表示する場所を選択します。`"auto"` は IDE の差分ビューアで開き、`"terminal"` はターミナルに保持します。Claude Code が VS Code または JetBrains IDE に接続されている場合のみ、`/config` に **Diff tool** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: 文字列、以下のいずれか：
  * `"auto"`: Claude Code は VS Code または JetBrains IDE が接続されているときに IDE の差分ビューアで差分を開きます
  * `"terminal"`: Claude Code は差分をターミナルに保持します
* **デフォルト**: `"auto"`

```json ~/.claude.json theme={null}
{
  "diffTool": "terminal"
}
```

Claude Code は `settings.json` でこのキーを無視します。

<h3 id="externaleditorcontext">
  `externalEditorContext`
</h3>

`Ctrl+G` を押すと、Claude Code は入力中のプロンプトを[外部エディタ](/docs/ja/interactive-mode#general-controls)で開きます。このキーをオンにすると、エディタバッファは Claude の前の応答で `#` コメント行として開始されるため、書き込み中に読むことができ、Claude Code は保存時にこれらの行を削除します。`/config` に **Show last response in external editor** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: エディタバッファは Claude の前の応答で `#` コメント行として開始され、Claude Code は保存時にこれらを削除します
  * `false`: エディタバッファはプロンプトのみで開きます
* **デフォルト**: `false`

```json ~/.claude.json theme={null}
{
  "externalEditorContext": true
}
```

オンにすると、Claude Code が開くバッファは次のようになり、マーカー行の下のテキストのみがプロンプトとして送信されます：

```text theme={null}
# ─── Claude's last response (for reference; removed on save) ───
# I added the retry loop to fetchUser in src/api.ts and a test
# for the timeout case. Want me to wire the same retry into
# fetchOrders?
# ─── Write your reply below this line ──────────────────────────

Yes, and cap it at three attempts.
```

Claude Code は応答の最後の 50 行を保持し、カットを `# … (earlier output truncated)` でマークします。

Claude Code は `settings.json` でこのキーを無視します。

<h3 id="leftarrowopensagents">
  `leftArrowOpensAgents`
</h3>

空のプロンプトで `←` を押して、[セッションをバックグラウンドにしてエージェントビューを開き](/docs/ja/agent-view#switch-sessions-without-leaving-the-terminal)ます。このキーを `false` に設定してショートカットをオフにします。エージェントビューが利用可能な場合、`/config` に **← opens agents** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: ターミナルで開始したセッションの空のプロンプトで `←` を押すと、セッションがバックグラウンドになり、エージェントビューが開きます
  * `false`: Claude Code はショートカットをオフにします。[エージェントビューから接続した](/docs/ja/agent-view#attach-to-a-session)セッションでは、空のプロンプトで `←` を押すと切断されます
* **デフォルト**: `true`

```json ~/.claude.json theme={null}
{
  "leftArrowOpensAgents": false
}
```

Claude Code は `settings.json` でこのキーを無視します。

<h3 id="permissionexplainerenabled">
  `permissionExplainerEnabled`
</h3>

<Warning>
  v2.1.257 で削除されました。Bash および PowerShell 権限プロンプトの `Ctrl+E` コマンド説明と一緒に削除されました。現在のバージョンでこれを設定しても効果はありません。
</Warning>

v2.1.256 まで、Bash または PowerShell 権限プロンプトで `Ctrl+E` を押してコマンドのモデル生成説明を表示でき、このキーを `false` に設定してそのショートカットをオフにできました。

* **スコープ**: [`グローバル設定`](#scopes)。v2.1.256 以前。
* **タイプ**: ブール値
* **デフォルト**: `true`

<h3 id="prstatusfooterenabled">
  `prStatusFooterEnabled`
</h3>

現在のブランチのオープンなプルリクエストまたはマージリクエストのバッジをプロンプトフッターに表示し、その[ステータス](/docs/ja/interactive-mode#pr-review-status)を示す色付きの下線を表示します。`/config` に **Show PR status footer** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: フッターは [PR レビューステータス](/docs/ja/interactive-mode#pr-review-status)の条件下でバッジを表示します
  * `false`: Claude Code はフッターのプルリクエストおよびマージリクエストチェックをスキップし、そのバッジを表示しません。[エージェントビューから接続した](/docs/ja/agent-view#attach-to-a-session)セッションは、[リンクされた](/docs/ja/agent-view#pull-request-status)プルリクエストへのプレーンリンクを表示できます
* **デフォルト**: `true`

```json ~/.claude.json theme={null}
{
  "prStatusFooterEnabled": false
}
```

Claude Code は `settings.json` でこのキーを無視します。

<h3 id="teammatedefaultmodel">
  `teammateDefaultModel`
</h3>

<Warning>
  v2.1.234 で削除されました。その `/config` 行 **Default teammate model** と一緒に削除されました。現在のバージョンでこれを設定しても効果はありません。
</Warning>

v2.1.233 まで、このキーを[エージェントチーム](/docs/ja/agent-teams#specify-teammates-and-models)のチームメイトのモデルに設定しました。プロンプトがモデルを指定しなかったチームメイト用：`"sonnet"` などのエイリアス、または `null` でリードのモデルに従う。Claude Code が現在そのようなチームメイト用に選択するモデルについては、[チームメイトとモデルを指定](/docs/ja/agent-teams#specify-teammates-and-models)を参照してください。

* **スコープ**: [`グローバル設定`](#scopes)。v2.1.233 以前。
* **タイプ**: 文字列、モデルエイリアスまたは完全なモデル ID、または `null`
* **デフォルト**: 未設定

<h2 id="see-also">
  関連項目
</h2>

* [権限を設定する](/docs/ja/permissions)：ルール構文、権限モード、ワークスペース信頼
* [環境変数](/docs/ja/env-vars)：Claude Code が読み込むすべての `CLAUDE_*`、`ANTHROPIC_*`、およびプロバイダー変数
* [Claude で利用可能なツール](/docs/ja/tools-reference)：組み込みツールと承認が必要なツール
* [設定ファイルの例](/docs/ja/settings-example)：個人用ファイル、チームファイル、および組織の管理ファイル
* [管理設定をセットアップする](/docs/ja/admin-setup)：組織が何を強制するかを決定する方法
* [管理設定をデプロイする](/docs/ja/managed-settings)：配信メカニズム、管理層内の優先順位、および管理設定の無効なエントリ
* [設定をデバッグする](/docs/ja/debug-your-config)：`claude doctor` と設定エラーダイアログ
