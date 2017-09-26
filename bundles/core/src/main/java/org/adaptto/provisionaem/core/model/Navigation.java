/*
 * #%L
 * Copyright (C) 2017 pro!vision GmbH
 * %%
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * #L%
 */
package org.adaptto.provisionaem.core.model;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.models.annotations.Model;

import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.PageFilter;
import com.day.cq.wcm.api.PageManager;

/**
 * Navigation model
 */
@Model(adaptables = SlingHttpServletRequest.class)
public final class Navigation {

  private final Page currentPage;
  private final Page rootPage;

  /**
   * @param request Request
   */
  public Navigation(SlingHttpServletRequest request) {
    PageManager pageManager = request.getResourceResolver().adaptTo(PageManager.class);
    currentPage = pageManager.getContainingPage(request.getResource());
    rootPage = currentPage.getAbsoluteParent(2);
  }

  /**
   * @return Navigation pages
   */
  public List<NavigationItem> getItems() {
    List<NavigationItem> items = new ArrayList<>();

    if (rootPage != null) {
      // root page
      items.add(toNavigationItem(rootPage));

      // children of root page
      Iterator<Page> children = rootPage.listChildren(new PageFilter(false, false));
      children.forEachRemaining(child -> items.add(toNavigationItem(child)));
    }

    return items;
  }

  private NavigationItem toNavigationItem(Page page) {
    boolean active = page.getPath().equals(currentPage.getPath());
    String href = page.getPath() + ".html";
    return new NavigationItem(page.getTitle(), href, active);
  }

}
